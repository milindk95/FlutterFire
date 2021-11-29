part of 'sign_up_verification_bloc.dart';

abstract class SignUpVerificationState extends Equatable {
  const SignUpVerificationState();

  @override
  List<Object> get props => [];
}

class SignUpVerificationInitial extends SignUpVerificationState {}

class SignUpVerificationInProgress extends SignUpVerificationState {}

class SignUpVerificationSuccess extends SignUpVerificationState {
  final User user;
  final String successMessage;

  SignUpVerificationSuccess(this.user, this.successMessage);
}

class SignUpVerificationFailure extends SignUpVerificationState {
  final String error;

  SignUpVerificationFailure(this.error);
}
