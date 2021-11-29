part of 'user_contests_bloc.dart';

abstract class UserContestsState {
  const UserContestsState();
}

class UserContestsFetching extends UserContestsState {}

class UserContestsFetchingSuccess extends UserContestsState {
  final List<Contest> contests;
  final bool reachToMaxIndex;

  UserContestsFetchingSuccess(
    this.contests, {
    this.reachToMaxIndex = false,
  });
}

class UserContestsPagingError extends UserContestsFetchingSuccess {
  final String error;

  UserContestsPagingError(List<Contest> contests, this.error) : super(contests);
}

class UserContestsRefreshingError extends UserContestsFetchingSuccess {
  final String error;

  UserContestsRefreshingError(List<Contest> contests, this.error)
      : super(contests);
}

class UserContestsFetchingFailure extends UserContestsState {
  final String error;

  UserContestsFetchingFailure(this.error);
}
