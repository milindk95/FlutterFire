part of 'recent_matches_bloc.dart';

abstract class RecentMatchesState extends Equatable {
  const RecentMatchesState();

  @override
  List<Object> get props => [];
}

class RecentMatchesFetching extends RecentMatchesState {}

class RecentMatchesFetchingSuccess extends RecentMatchesState {
  final List<MyMatch> myMatches;

  RecentMatchesFetchingSuccess(this.myMatches);
}

class RecentMatchesFetchingFailure extends RecentMatchesState {
  final String error;

  RecentMatchesFetchingFailure(this.error);
}
