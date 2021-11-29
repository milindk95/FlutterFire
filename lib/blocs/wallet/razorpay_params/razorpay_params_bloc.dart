import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:the_super11/core/preferences.dart';
import 'package:the_super11/repository/wallet/add_money_repository.dart';

part 'razorpay_params_event.dart';
part 'razorpay_params_state.dart';

class RazorpayParamsBloc
    extends Bloc<RazorpayParamsEvent, RazorpayParamsState> {
  final _addMoneyRepo = AddMoneyRepository();

  RazorpayParamsBloc() : super(RazorpayParamsInitial());

  @override
  Stream<RazorpayParamsState> mapEventToState(
      RazorpayParamsEvent event) async* {
    if (event is GetRazorpayParams) {
      yield RazorpayParamsFetching();
      final result = await _addMoneyRepo.addMoney({'amount': event.amount}
        ..addAll(event.offerId != null
            ? {'appliedOfferId': event.offerId, 'offerApplied': true}
            : {}));
      if (result.data != null) {
        final params = result.data!;
        final user = await Preference.getUserData();
        final razorpayParams = {
          'key': kDebugMode ? 'rzp_test_9a0nU5CzYZ8uio' : params.apiKey,
          'amount': params.amount,
          'name': user?.teamName ?? '',
          'order_id': params.id,
          'description': "Add Money to TheSuper11 Wallet",
          'prefill': {
            'contact': user?.mobile ?? '',
            'email': user?.email ?? ''
          },
          'theme': {'color': '#9E1030', 'backdrop_color': '#9E1030'},
          'modal': {'confirm_close': true}
        };
        yield RazorpayParamsFetchingSuccess(razorpayParams);
      } else
        yield RazorpayParamsFetchingFailure(result.error);
    }
  }
}
