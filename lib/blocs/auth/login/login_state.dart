part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginAuthenticating extends LoginState {}

class LoginAuthenticationSuccess extends LoginState {
  final User user;
  final String message;

  LoginAuthenticationSuccess(this.message, this.user);
}

class LoginAuthenticationFailure extends LoginState {
  final String error;
  final int? statusCode;
  final String userId;

  LoginAuthenticationFailure({
    required this.error,
    this.statusCode,
    required this.userId,
  });
}
