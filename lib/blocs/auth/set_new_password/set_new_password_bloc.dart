import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_super11/repository/auth/set_new_password_repository.dart';

part 'set_new_password_event.dart';
part 'set_new_password_state.dart';

class SetNewPasswordBloc
    extends Bloc<SetNewPasswordEvent, SetNewPasswordState> {
  final _newPasswordRepo = SetNewPasswordRepository();

  SetNewPasswordBloc() : super(SetNewPasswordInitial());

  @override
  Stream<SetNewPasswordState> mapEventToState(
      SetNewPasswordEvent event) async* {
    if (event is SetNewPassword) {
      yield SetNewPasswordInProgress();
      final result = await _newPasswordRepo.setNewPassword(event.body);
      if (result.data != null)
        yield SetNewPasswordSuccess(result.data!);
      else
        yield SetNewPasswordFailure(result.error);
    }
  }
}
