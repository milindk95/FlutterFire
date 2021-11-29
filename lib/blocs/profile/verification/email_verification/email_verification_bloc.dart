import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/repository/profile/verification/email_verification_repository.dart';

part 'email_verification_event.dart';

part 'email_verification_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  final _verificationRepository = EmailVerificationRepository();

  EmailVerificationBloc() : super(EmailVerificationInitial());

  @override
  Stream<EmailVerificationState> mapEventToState(
      EmailVerificationEvent event) async* {
    if (event is VerifyEmail) {
      final result =
          await _verificationRepository.verifyEmailOTP({'otp': event.otp});
      if (result.statusCode == 200)
        yield EmailVerificationSuccess(result.data!);
      else
        yield EmailVerificationFailure(result.error);
    }
  }
}
