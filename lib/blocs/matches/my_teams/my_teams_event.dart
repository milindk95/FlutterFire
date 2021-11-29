part of 'my_teams_bloc.dart';

abstract class MyTeamsEvent extends Equatable {
  const MyTeamsEvent();

  @override
  List<Object?> get props => [];
}

class GetMyTeams extends MyTeamsEvent {}

class ResetMyTeams extends MyTeamsEvent {}
