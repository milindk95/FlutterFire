part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => [];
}

class EditProfile extends EditProfileEvent {
  final Map<String, dynamic> payload;

  EditProfile(this.payload);
}
