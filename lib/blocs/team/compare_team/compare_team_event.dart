part of 'compare_team_bloc.dart';

abstract class CompareTeamEvent extends Equatable {
  const CompareTeamEvent();

  @override
  List<Object?> get props => [];
}

class CompareTeam extends CompareTeamEvent {
  final List<String> teamsId;

  CompareTeam(this.teamsId);
}
