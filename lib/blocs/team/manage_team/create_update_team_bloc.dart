import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/repository/team/create_update_team_repository.dart';

part 'create_update_team_event.dart';
part 'create_update_team_state.dart';

class CreateUpdateTeamBloc
    extends Bloc<CreateUpdateTeamEvent, CreateUpdateTeamState> {
  final _teamRepo = CreateUpdateTeamRepository();

  CreateUpdateTeamBloc() : super(CreateUpdateTeamInitial());

  @override
  Stream<CreateUpdateTeamState> mapEventToState(
      CreateUpdateTeamEvent event) async* {
    if (event is CreateTeam) {
      yield CreateUpdateTeamInProgress();
      final result = await _teamRepo.createTeam(event.body);
      if (result.data != null)
        yield CreateUpdateTeamSuccess(result.data!);
      else
        yield CreateUpdateTeamFailure(result.error);
    } else if (event is UpdateTeam) {
      final result = await _teamRepo.updateTeam(event.teamId, event.body);
      if (result.data != null)
        yield CreateUpdateTeamSuccess(result.data!);
      else
        yield CreateUpdateTeamFailure(result.error);
    }
  }
}
