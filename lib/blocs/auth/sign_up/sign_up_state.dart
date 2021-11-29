part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpInProgress extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final User user;

  SignUpSuccess(this.user);
}

class SignUpFailure extends SignUpState {
  final String error;

  SignUpFailure(this.error);
}
