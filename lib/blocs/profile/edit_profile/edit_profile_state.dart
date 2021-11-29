part of 'edit_profile_bloc.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class EditProfileInProgress extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final String message;

  EditProfileSuccess(this.message);
}

class EditProfileFailure extends EditProfileState {
  final String error;

  EditProfileFailure(this.error);
}
