part of 'all_upcoming_matches_bloc.dart';

@immutable
abstract class AllUpcomingMatchesState {}

class AllUpcomingMatchesFetching extends AllUpcomingMatchesState {}

class AllUpcomingMatchesFetchingSuccess extends AllUpcomingMatchesState {
  final List<MyMatch> myMatches;
  final bool reachToMaxIndex;

  AllUpcomingMatchesFetchingSuccess(
    this.myMatches, {
    this.reachToMaxIndex = false,
  });
}

/// Upcoming matches pagination error
class AllUpcomingMatchesPagingError extends AllUpcomingMatchesFetchingSuccess {
  final String error;

  AllUpcomingMatchesPagingError(List<MyMatch> matches, this.error)
      : super(matches);
}

/// Upcoming matches refresh error
class AllUpcomingMatchesRefreshingError
    extends AllUpcomingMatchesFetchingSuccess {
  final String error;

  AllUpcomingMatchesRefreshingError(List<MyMatch> matches, this.error)
      : super(matches);
}

class AllUpcomingMatchesFetchingFailure extends AllUpcomingMatchesState {
  final String error;

  AllUpcomingMatchesFetchingFailure(this.error);
}
