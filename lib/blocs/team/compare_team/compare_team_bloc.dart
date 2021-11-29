import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/repository/matches/team_details_repository.dart';

part 'compare_team_event.dart';
part 'compare_team_state.dart';

class CompareTeamBloc extends Bloc<CompareTeamEvent, CompareTeamState> {
  final _teamDetailsRepo = TeamDetailsRepository();

  CompareTeamBloc() : super(CompareTeamFetching());

  @override
  Stream<CompareTeamState> mapEventToState(CompareTeamEvent event) async* {
    if (event is CompareTeam) {
      final team1Result =
          await _teamDetailsRepo.getTeamDetails(event.teamsId[0]);
      final team2Result =
          await _teamDetailsRepo.getTeamDetails(event.teamsId[1]);
      if (team1Result.data != null && team2Result.data != null)
        yield CompareTeamFetchingSuccess(
            [team1Result.data!, team2Result.data!]);
      else
        CompareTeamFetchingFailure(team1Result.error);
    }
  }
}
