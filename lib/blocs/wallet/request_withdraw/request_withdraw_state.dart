part of 'request_withdraw_bloc.dart';

abstract class RequestWithdrawState extends Equatable {
  const RequestWithdrawState();

  @override
  List<Object> get props => [];
}

class RequestWithdrawInitial extends RequestWithdrawState {}

class RequestWithdrawProcessing extends RequestWithdrawState {}

class RequestWithdrawSuccess extends RequestWithdrawState {
  final String message;

  RequestWithdrawSuccess(this.message);
}

class RequestWithdrawFailure extends RequestWithdrawState {
  final String error;

  RequestWithdrawFailure(this.error);
}
