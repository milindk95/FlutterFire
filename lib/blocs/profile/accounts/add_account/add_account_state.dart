part of 'add_account_bloc.dart';

abstract class AddAccountState extends Equatable {
  const AddAccountState();

  @override
  List<Object> get props => [];
}

class AddAccountInitial extends AddAccountState {}

class AddAccountInProgress extends AddAccountState {}

class AddAccountSuccess extends AddAccountState {
  final String message;

  AddAccountSuccess(this.message);
}

class AddAccountFailure extends AddAccountState {
  final String error;

  AddAccountFailure(this.error);
}
