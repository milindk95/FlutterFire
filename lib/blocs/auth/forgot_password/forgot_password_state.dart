part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordInProgress extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String userId;
  final String forgotPasswordId;

  ForgotPasswordSuccess(this.userId, this.forgotPasswordId);
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String error;

  ForgotPasswordFailure(this.error);
}
