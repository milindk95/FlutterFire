part of 'create_update_team_bloc.dart';

abstract class CreateUpdateTeamEvent extends Equatable {
  const CreateUpdateTeamEvent();

  @override
  List<Object?> get props => [];
}

class CreateTeam extends CreateUpdateTeamEvent {
  final Map<String, dynamic> body;

  CreateTeam(this.body);
}

class UpdateTeam extends CreateUpdateTeamEvent {
  final String teamId;
  final Map<String, dynamic> body;

  UpdateTeam(this.teamId, this.body);
}
