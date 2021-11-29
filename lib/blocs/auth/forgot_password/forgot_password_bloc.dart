import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/repository/auth/forgot_password_repository.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final _forgotPasswordRepo = ForgotPasswordRepository();

  ForgotPasswordBloc() : super(ForgotPasswordInitial());

  @override
  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
    if (event is ForgotPasswordByMobileNo) {
      yield ForgotPasswordInProgress();
      final result =
          await _forgotPasswordRepo.forgotPassword({'mobile': event.mobileNo});
      yield* _handleResult(result);
    } else if (event is ForgotPasswordByEmail) {
      yield ForgotPasswordInProgress();
      final result =
          await _forgotPasswordRepo.forgotPassword({'email': event.email});
      yield* _handleResult(result);
    }
  }

  Stream<ForgotPasswordState> _handleResult(
      ApiResponse<Map<String, String>> result) async* {
    if (result.data != null) {
      yield ForgotPasswordSuccess(
        result.data!['userId'] ?? '',
        result.data!['forgotPasswordId'] ?? '',
      );
    } else
      yield ForgotPasswordFailure(result.error);
  }
}
