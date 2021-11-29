part of 'request_withdraw_bloc.dart';

abstract class RequestWithdrawEvent extends Equatable {
  const RequestWithdrawEvent();

  @override
  List<Object?> get props => [];
}

class RequestForWithdraw extends RequestWithdrawEvent {
  final String withdrawAmount;
  final String selectedAccountId;

  RequestForWithdraw(this.withdrawAmount, this.selectedAccountId);
}
