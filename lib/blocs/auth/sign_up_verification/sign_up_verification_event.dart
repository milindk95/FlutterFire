part of 'sign_up_verification_bloc.dart';

abstract class SignUpVerificationEvent extends Equatable {
  const SignUpVerificationEvent();

  @override
  List<Object?> get props => [];
}

class VerifyAccountByOTP extends SignUpVerificationEvent {
  final int otp;

  VerifyAccountByOTP(this.otp);
}
