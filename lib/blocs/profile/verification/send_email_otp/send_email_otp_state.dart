part of 'send_email_otp_bloc.dart';

abstract class SendEmailOtpState extends Equatable {
  const SendEmailOtpState();

  @override
  List<Object> get props => [];
}

class SendEmailOtpInitial extends SendEmailOtpState {}

class SendEmailOtpInProgress extends SendEmailOtpState {}

class SendEmailOtpSuccess extends SendEmailOtpState {}

class SendEmailOtpFailure extends SendEmailOtpState {
  final String error;

  SendEmailOtpFailure(this.error);
}
