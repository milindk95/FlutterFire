part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordByMobileNo extends ForgotPasswordEvent {
  final String mobileNo;

  ForgotPasswordByMobileNo(this.mobileNo);
}

class ForgotPasswordByEmail extends ForgotPasswordEvent {
  final String email;

  ForgotPasswordByEmail(this.email);
}
