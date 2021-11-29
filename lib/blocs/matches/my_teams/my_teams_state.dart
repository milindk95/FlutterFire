part of 'my_teams_bloc.dart';

abstract class MyTeamsState extends Equatable {
  const MyTeamsState();

  @override
  List<Object> get props => [];
}

class MyTeamsFetching extends MyTeamsState {}

class MyTeamsFetchingSuccess extends MyTeamsState {
  final MyTeam myTeam;

  MyTeamsFetchingSuccess(this.myTeam);
}

class MyTeamsFetchingFailure extends MyTeamsState {
  final String error;

  MyTeamsFetchingFailure(this.error);

  @override
  List<Object> get props => [error];
}
