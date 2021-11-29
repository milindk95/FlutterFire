part of 'compare_team_bloc.dart';

abstract class CompareTeamState extends Equatable {
  const CompareTeamState();

  @override
  List<Object> get props => [];
}

class CompareTeamFetching extends CompareTeamState {}

class CompareTeamFetchingSuccess extends CompareTeamState {
  final List<Team> teams;

  CompareTeamFetchingSuccess(this.teams);
}

class CompareTeamFetchingFailure extends CompareTeamState {
  final String error;

  CompareTeamFetchingFailure(this.error);
}
