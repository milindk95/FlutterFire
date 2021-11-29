import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/repository/wallet/my_referral_repository.dart';

part 'my_referral_event.dart';

part 'my_referral_state.dart';

class MyReferralBloc extends Bloc<MyReferralEvent, MyReferralState> {
  MyReferralRepository _myReferralRepo = MyReferralRepository();

  MyReferralBloc() : super(MyReferralFetching());

  @override
  Stream<MyReferralState> mapEventToState(MyReferralEvent event) async* {
    if (event is GetMyReferral) {
      final result = await _myReferralRepo.getMyReferral();
      if (result.data != null)
        yield MyReferralFetchingSuccess(result.data!);
      else
        yield MyReferralFetchingFailure(result.error);
    }
  }
}
