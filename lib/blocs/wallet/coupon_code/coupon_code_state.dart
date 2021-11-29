part of 'coupon_code_bloc.dart';

abstract class CouponCodeState extends Equatable {
  const CouponCodeState();

  @override
  List<Object> get props => [];
}

class CouponCodeInitial extends CouponCodeState {}

class CouponCodeApplying extends CouponCodeState {}

class CouponCodeApplyingSuccess extends CouponCodeState {
  final String message;
  final Coupon coupon;

  CouponCodeApplyingSuccess(this.message, this.coupon);
}

class CouponCodeApplyingFailure extends CouponCodeState {
  final String error;

  CouponCodeApplyingFailure(this.error);
}
