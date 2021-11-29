import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/repository/matches/team_and_contest_count_repository.dart';

part 'team_and_contest_count_event.dart';
part 'team_and_contest_count_state.dart';

class TeamAndContestCountBloc
    extends Bloc<TeamAndContestCountEvent, TeamAndContestCountState> {
  late TeamAndContestCountRepository _teamAndContestCountRepo;

  TeamAndContestCountBloc() : super(TeamAndContestCountFetching());

  void setMatchId(String matchId) {
    _teamAndContestCountRepo = TeamAndContestCountRepository(matchId);
    add(GetTeamAndContestCount());
  }

  @override
  Stream<TeamAndContestCountState> mapEventToState(
      TeamAndContestCountEvent event) async* {
    if (event is GetTeamAndContestCount) {
      yield TeamAndContestCountFetching();
      final result = await _teamAndContestCountRepo.getTeamAndContestCount();
      if (result.data != null)
        yield TeamAndContestCountFetchingSuccess(
            result.data!['team'] ?? 0, result.data!['contest'] ?? 0);
      else
        yield TeamAndContestCountFetchingFailure(result.error);
    } else if (event is ResetTeamAndContestCount) {
      yield TeamAndContestCountFetching();
    }
  }
}
