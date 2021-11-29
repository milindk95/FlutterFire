part of 'match_point_bloc.dart';

abstract class MatchPointState {
  const MatchPointState();
}

class MatchPointFetching extends MatchPointState {}

class MatchPointFetchingSuccess extends MatchPointState {
  final MatchPoint matchPoint;

  MatchPointFetchingSuccess(this.matchPoint);
}

class MatchPointRefreshingError extends MatchPointFetchingSuccess {
  final String error;

  MatchPointRefreshingError(MatchPoint matchPoint, this.error)
      : super(matchPoint);
}

class MatchPointFetchingFailure extends MatchPointState {
  final String error;

  MatchPointFetchingFailure(this.error);
}
