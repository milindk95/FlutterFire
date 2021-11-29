part of 'send_email_otp_bloc.dart';

abstract class SendEmailOtpEvent extends Equatable {
  const SendEmailOtpEvent();

  @override
  List<Object?> get props => [];
}

class SendEmailOTP extends SendEmailOtpEvent {}
