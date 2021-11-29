import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/repository/matches/my_teams_repository.dart';

part 'match_point_event.dart';
part 'match_point_state.dart';

class MatchPointBloc extends Bloc<MatchPointEvent, MatchPointState> {
  final String _matchId;
  late final MyTeamsRepository _myTeamsRepo;
  MatchPoint _matchPoint = MatchPoint();

  MatchPointBloc(this._matchId) : super(MatchPointFetching()) {
    _myTeamsRepo = MyTeamsRepository(_matchId);
  }

  @override
  Stream<MatchPointState> mapEventToState(MatchPointEvent event) async* {
    if (event is GetMatchPoint) {
      yield MatchPointFetching();
      final result = await _myTeamsRepo.getMatchPoint();
      if (result.data != null) {
        _matchPoint = result.data!;
        yield MatchPointFetchingSuccess(_matchPoint);
      } else
        yield MatchPointFetchingFailure(result.error);
    } else if (event is RefreshMatchPoint) {
      final result = await _myTeamsRepo.getMatchPoint();
      if (result.data != null) {
        _matchPoint = result.data!;
        yield MatchPointFetchingSuccess(_matchPoint);
      } else
        yield MatchPointRefreshingError(_matchPoint, result.error);
    }
  }
}
