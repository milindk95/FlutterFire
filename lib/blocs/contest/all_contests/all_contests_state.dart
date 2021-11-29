part of 'all_contests_bloc.dart';

abstract class AllContestsState {
  const AllContestsState();
}

class AllContestsFetching extends AllContestsState {}

class AllContestsFetchingSuccess extends AllContestsState {
  final ContestData contestData;

  AllContestsFetchingSuccess(this.contestData);
}

class AllContestsRefreshingError extends AllContestsFetchingSuccess {
  final String error;

  AllContestsRefreshingError(ContestData contestData, this.error)
      : super(contestData);
}

class AllContestsFetchingFailure extends AllContestsState {
  final String error;

  AllContestsFetchingFailure(this.error);
}
