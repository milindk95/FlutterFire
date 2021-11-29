import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/repository/auth/sign_up_repository.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final _signUpRepo = SignUpRepository();

  SignUpBloc() : super(SignUpInitial());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUp) {
      yield SignUpInProgress();
      final result = await _signUpRepo.signUp(event.body);
      if (result.data != null)
        yield SignUpSuccess(result.data!);
      else
        yield SignUpFailure(result.error);
    }
  }
}
