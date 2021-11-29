part of 'coupon_code_bloc.dart';

abstract class CouponCodeEvent extends Equatable {
  const CouponCodeEvent();

  @override
  List<Object?> get props => [];
}

class ApplyCouponCode extends CouponCodeEvent {
  final String amount;
  final String offerCode;

  ApplyCouponCode({required this.amount, required this.offerCode});
}

class ResetCouponCode extends CouponCodeEvent {}
