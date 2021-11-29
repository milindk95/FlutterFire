part of 'email_verification_bloc.dart';

abstract class EmailVerificationEvent extends Equatable {
  const EmailVerificationEvent();

  @override
  List<Object?> get props => [];
}

class VerifyEmail extends EmailVerificationEvent {
  final int otp;

  VerifyEmail(this.otp);
}
