part of 'user_accounts_bloc.dart';

abstract class UserAccountsState extends Equatable {
  const UserAccountsState();

  @override
  List<Object> get props => [];
}

class UserAccountsFetching extends UserAccountsState {}

class UserAccountsFetchingSuccess extends UserAccountsState {
  final List<UserAccount> accounts;

  UserAccountsFetchingSuccess(this.accounts);
}

class UserAccountsFetchingFailure extends UserAccountsState {
  final String error;

  UserAccountsFetchingFailure(this.error);
}
