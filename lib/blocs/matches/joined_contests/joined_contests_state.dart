part of 'joined_contests_bloc.dart';

@immutable
abstract class JoinedContestsState {}

class JoinedContestsFetching extends JoinedContestsState {}

class JoinedContestsFetchingSuccess extends JoinedContestsState {
  final List<Contest> contests;
  final bool reachToMaxIndex;

  JoinedContestsFetchingSuccess(
    this.contests, {
    this.reachToMaxIndex = false,
  });
}

class JoinedContestsPagingError extends JoinedContestsFetchingSuccess {
  final String error;

  JoinedContestsPagingError(List<Contest> contests, this.error)
      : super(contests);
}

class JoinedContestsRefreshingError extends JoinedContestsFetchingSuccess {
  final String error;

  JoinedContestsRefreshingError(List<Contest> contests, this.error)
      : super(contests);
}

class JoinedContestsFetchingFailure extends JoinedContestsState {
  final String error;

  JoinedContestsFetchingFailure(this.error);
}
