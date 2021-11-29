import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_super11/repository/profile/verification/email_verification_repository.dart';

part 'send_email_otp_event.dart';

part 'send_email_otp_state.dart';

class SendEmailOtpBloc extends Bloc<SendEmailOtpEvent, SendEmailOtpState> {
  final _emailVerificationRepo = EmailVerificationRepository();

  SendEmailOtpBloc() : super(SendEmailOtpInitial());

  @override
  Stream<SendEmailOtpState> mapEventToState(SendEmailOtpEvent event) async* {
    if (event is SendEmailOTP) {
      final result = await _emailVerificationRepo.sendEmailOTP();
      if (result.statusCode == 200)
        yield SendEmailOtpSuccess();
      else
        yield SendEmailOtpFailure(result.error);
    }
  }
}
