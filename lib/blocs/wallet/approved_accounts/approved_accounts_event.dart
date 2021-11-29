part of 'approved_accounts_bloc.dart';

abstract class ApprovedAccountsEvent extends Equatable {
  const ApprovedAccountsEvent();

  @override
  List<Object?> get props => [];
}

class GetApprovedAccounts extends ApprovedAccountsEvent {}
