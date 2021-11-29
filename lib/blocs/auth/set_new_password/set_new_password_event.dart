part of 'set_new_password_bloc.dart';

abstract class SetNewPasswordEvent extends Equatable {
  const SetNewPasswordEvent();

  @override
  List<Object?> get props => [];
}

class SetNewPassword extends SetNewPasswordEvent {
  final Map<String, dynamic> body;

  SetNewPassword(this.body);
}
