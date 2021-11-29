part of 'my_matches_bloc.dart';

@immutable
abstract class MyMatchesState {}

class MyMatchesFetching extends MyMatchesState {}

class MyMatchesFetchingSuccess extends MyMatchesState {
  final List<MyMatch> myMatches;
  final bool reachToMaxIndex;

  MyMatchesFetchingSuccess(
    this.myMatches, {
    this.reachToMaxIndex = false,
  });
}

/// My matches pagination error
class MyMatchesPagingError extends MyMatchesFetchingSuccess {
  final String error;

  MyMatchesPagingError(List<MyMatch> matches, this.error) : super(matches);
}

/// My matches refresh error
class MyMatchesRefreshingError extends MyMatchesFetchingSuccess {
  final String error;

  MyMatchesRefreshingError(List<MyMatch> matches, this.error) : super(matches);
}

class MyMatchesFetchingFailure extends MyMatchesState {
  final String error;

  MyMatchesFetchingFailure(this.error);
}
