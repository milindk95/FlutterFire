part of 'razorpay_params_bloc.dart';

abstract class RazorpayParamsEvent extends Equatable {
  const RazorpayParamsEvent();

  @override
  List<Object?> get props => [];
}

class GetRazorpayParams extends RazorpayParamsEvent {
  final String amount;
  final String? offerId;

  GetRazorpayParams({required this.amount, this.offerId});
}
