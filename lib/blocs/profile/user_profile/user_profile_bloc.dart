import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_super11/core/preferences.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/repository/profile/user_profile_repository.dart';

part 'user_profile_event.dart';

part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserProfileRepository _userProfileRepo = UserProfileRepository();
  UserProfileBloc() : super(UserProfileFetching());

  @override
  Stream<UserProfileState> mapEventToState(UserProfileEvent event) async* {
    if (event is GetUserProfile) {
      yield UserProfileFetching();
      final response = await _userProfileRepo.getProfile();
      if (response.data != null) {
        await Preference.setUserData(response.data!);
        yield UserProfileFetchingSuccess(response.data!);
      } else
        yield UserProfileFetchingFailure(response.error);
    }
  }
}
