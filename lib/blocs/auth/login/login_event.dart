part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginWithMobileNoAndPassword extends LoginEvent {
  final String mobileNo, password;

  LoginWithMobileNoAndPassword(this.mobileNo, this.password);
}

class LoginWithEmailAndPassword extends LoginEvent {
  final String email, password;

  LoginWithEmailAndPassword(this.email, this.password);
}
