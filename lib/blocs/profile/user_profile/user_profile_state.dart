part of 'user_profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileFetching extends UserProfileState {}

class UserProfileFetchingSuccess extends UserProfileState {
  final User user;

  UserProfileFetchingSuccess(this.user);
}

class UserProfileFetchingFailure extends UserProfileState {
  final String error;

  UserProfileFetchingFailure(this.error);
}
