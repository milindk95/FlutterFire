import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_super11/repository/profile/edit_profile_repository.dart';

part 'edit_profile_event.dart';

part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final EditProfileRepository _editProfileRepo = EditProfileRepository();
  EditProfileBloc() : super(EditProfileInitial());

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is EditProfile) {
      yield EditProfileInProgress();
      final response = await _editProfileRepo.editProfile(event.payload);
      if (response.data != null) {
        yield EditProfileSuccess(response.data!);
      } else
        yield EditProfileFailure(response.error);
    }
  }
}
