import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/core/preferences.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/repository/auth/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepo = LoginRepository();

  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithMobileNoAndPassword) {
      yield LoginAuthenticating();
      final result = await _loginRepo
          .login({'mobile': event.mobileNo, 'password': event.password});
      yield* _handleResult(result);
    } else if (event is LoginWithEmailAndPassword) {
      yield LoginAuthenticating();
      final result = await _loginRepo
          .login({'email': event.email, 'password': event.password});
      yield* _handleResult(result);
    }
  }

  Stream<LoginState> _handleResult(
      ApiResponse<Map<String, dynamic>> result) async* {
    if (result.statusCode == 200) {
      final user = User.fromJson(result.data!['data']);
      await Preference.setUserData(user);
      yield LoginAuthenticationSuccess(result.successMessage, user);
    } else
      yield LoginAuthenticationFailure(
        error: result.error,
        userId: result.data?['data']?['userId'] ?? '',
        statusCode: result.statusCode,
      );
  }
}
