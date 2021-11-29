import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/repository/matches/team_details_repository.dart';

part 'team_details_event.dart';
part 'team_details_state.dart';

class TeamDetailsBloc extends Bloc<TeamDetailsEvent, TeamDetailsState> {
  final _teamDetailsRepo = TeamDetailsRepository();

  TeamDetailsBloc() : super(TeamDetailsInitial());

  @override
  Stream<TeamDetailsState> mapEventToState(TeamDetailsEvent event) async* {
    if (event is GetTeamDetails) {
      yield TeamDetailsFetching();
      final result = await _teamDetailsRepo.getTeamDetails(event.teamId);
      if (result.data != null)
        yield TeamDetailsFetchingSuccess(result.data!);
      else
        yield TeamDetailsFetchingFailure(result.error);
    }
  }
}
