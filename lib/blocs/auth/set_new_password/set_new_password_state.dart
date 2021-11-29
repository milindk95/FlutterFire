part of 'set_new_password_bloc.dart';

abstract class SetNewPasswordState extends Equatable {
  const SetNewPasswordState();

  @override
  List<Object> get props => [];
}

class SetNewPasswordInitial extends SetNewPasswordState {}

class SetNewPasswordInProgress extends SetNewPasswordState {}

class SetNewPasswordSuccess extends SetNewPasswordState {
  final String message;

  SetNewPasswordSuccess(this.message);
}

class SetNewPasswordFailure extends SetNewPasswordState {
  final String error;

  SetNewPasswordFailure(this.error);
}
