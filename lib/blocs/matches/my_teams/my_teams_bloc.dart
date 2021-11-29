import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/repository/matches/my_teams_repository.dart';

part 'my_teams_event.dart';
part 'my_teams_state.dart';

class MyTeamsBloc extends Bloc<MyTeamsEvent, MyTeamsState> {
  late MyTeamsRepository _myTeamsRepo;

  MyTeamsBloc() : super(MyTeamsFetching());

  void setMatchId(String matchId) {
    _myTeamsRepo = MyTeamsRepository(matchId);
    add(GetMyTeams());
  }

  @override
  Stream<MyTeamsState> mapEventToState(MyTeamsEvent event) async* {
    if (event is GetMyTeams) {
      yield MyTeamsFetching();
      final result = await _myTeamsRepo.getMyTeams();
      if (result.data != null)
        yield MyTeamsFetchingSuccess(result.data!);
      else
        yield MyTeamsFetchingFailure(result.error);
    } else if (event is ResetMyTeams) {
      yield MyTeamsFetching();
    }
  }
}
