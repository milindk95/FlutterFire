part of 'create_update_team_bloc.dart';

abstract class CreateUpdateTeamState extends Equatable {
  const CreateUpdateTeamState();

  @override
  List<Object> get props => [];
}

class CreateUpdateTeamInitial extends CreateUpdateTeamState {}

class CreateUpdateTeamInProgress extends CreateUpdateTeamState {}

class CreateUpdateTeamSuccess extends CreateUpdateTeamState {
  final String message;

  CreateUpdateTeamSuccess(this.message);
}

class CreateUpdateTeamFailure extends CreateUpdateTeamState {
  final String error;

  CreateUpdateTeamFailure(this.error);
}
