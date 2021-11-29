part of 'razorpay_params_bloc.dart';

abstract class RazorpayParamsState extends Equatable {
  const RazorpayParamsState();

  @override
  List<Object> get props => [];
}

class RazorpayParamsInitial extends RazorpayParamsState {}

class RazorpayParamsFetching extends RazorpayParamsState {}

class RazorpayParamsFetchingSuccess extends RazorpayParamsState {
  final Map<String, dynamic> options;

  RazorpayParamsFetchingSuccess(this.options);
}

class RazorpayParamsFetchingFailure extends RazorpayParamsState {
  final String error;

  RazorpayParamsFetchingFailure(this.error);
}
