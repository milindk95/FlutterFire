part of 'approved_accounts_bloc.dart';

abstract class ApprovedAccountsState extends Equatable {
  const ApprovedAccountsState();

  @override
  List<Object> get props => [];
}

class ApprovedAccountsFetching extends ApprovedAccountsState {}

class ApprovedAccountsFetchingSuccess extends ApprovedAccountsState {
  final List<Account> accounts;

  ApprovedAccountsFetchingSuccess(this.accounts);
}

class ApprovedAccountsFetchingFailure extends ApprovedAccountsState {
  final String error;

  ApprovedAccountsFetchingFailure(this.error);
}
