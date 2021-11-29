import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/core/extensions.dart';
import 'package:flutter_fire/core/preferences.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/repository/auth/sign_up_verification_repository.dart';

part 'sign_up_verification_event.dart';
part 'sign_up_verification_state.dart';

class SignUpVerificationBloc
    extends Bloc<SignUpVerificationEvent, SignUpVerificationState> {
  final String _userId;
  final String _mobileNoOrEmail;
  final _verificationRepo = SignUpVerificationRepository();

  SignUpVerificationBloc(this._userId, this._mobileNoOrEmail)
      : super(SignUpVerificationInitial());

  @override
  Stream<SignUpVerificationState> mapEventToState(
      SignUpVerificationEvent event) async* {
    if (event is VerifyAccountByOTP) {
      yield SignUpVerificationInProgress();
      final key = _mobileNoOrEmail.isValidEmail ? 'email' : 'mobile';
      final result = await _verificationRepo.signUpVerification(
          {key: _mobileNoOrEmail, 'otp': event.otp, 'userId': _userId});
      if (result.data != null) {
        await Preference.setUserData(result.data!);
        yield SignUpVerificationSuccess(result.data!, result.successMessage);
      } else
        yield SignUpVerificationFailure(result.error);
    }
  }
}
