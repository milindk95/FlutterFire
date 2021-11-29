import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/repository/wallet/coupon_code_repository.dart';

part 'coupon_code_event.dart';
part 'coupon_code_state.dart';

class CouponCodeBloc extends Bloc<CouponCodeEvent, CouponCodeState> {
  final _couponCodeRepo = CouponCodeRepository();

  CouponCodeBloc() : super(CouponCodeInitial());

  @override
  Stream<CouponCodeState> mapEventToState(CouponCodeEvent event) async* {
    if (event is ApplyCouponCode) {
      yield CouponCodeApplying();
      final result = await _couponCodeRepo.applyCouponCode({
        'amount': event.amount,
        'offerCode': event.offerCode.toUpperCase(),
      });
      if (result.data != null) {
        final append =
            'You will get extra ₹${result.data!.cashBonus != 0 ? result.data!.cashBonus : result.data!.depositBonus}';
        yield CouponCodeApplyingSuccess(
            '${result.successMessage} $append', result.data!);
      } else
        yield CouponCodeApplyingFailure(result.error);
    } else if (event is ResetCouponCode) yield CouponCodeInitial();
  }
}
