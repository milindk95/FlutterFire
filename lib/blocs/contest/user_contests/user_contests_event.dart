part of 'user_contests_bloc.dart';

abstract class UserContestsEvent {}

class GetUserContests extends UserContestsEvent {}

class PagingUserContests extends UserContestsEvent {}

class RefreshUserContests extends UserContestsEvent {}

class ResetUserContests extends UserContestsEvent {}
