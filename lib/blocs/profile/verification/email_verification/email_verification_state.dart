part of 'email_verification_bloc.dart';

abstract class EmailVerificationState extends Equatable {
  const EmailVerificationState();

  @override
  List<Object> get props => [];
}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationInProgress extends EmailVerificationState {}

class EmailVerificationSuccess extends EmailVerificationState {
  final String message;

  EmailVerificationSuccess(this.message);
}

class EmailVerificationFailure extends EmailVerificationState {
  final String error;

  EmailVerificationFailure(this.error);
}
