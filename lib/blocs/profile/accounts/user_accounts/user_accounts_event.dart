part of 'user_accounts_bloc.dart';

abstract class AllAccountsEvent extends Equatable {
  const AllAccountsEvent();

  @override
  List<Object?> get props => [];
}

class GetAllAccounts extends AllAccountsEvent {}
