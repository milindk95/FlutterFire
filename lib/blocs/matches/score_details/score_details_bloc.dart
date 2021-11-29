import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/repository/matches/score_details_repository.dart';

part 'score_details_event.dart';
part 'score_details_state.dart';

class ScoreDetailsBloc extends Bloc<ScoreDetailsEvent, ScoreDetailsState> {
  late ScoreDetailsRepository _scoreDetailsRepo;
  Score? _score;

  ScoreDetailsBloc() : super(ScoreDetailsFetching());

  void setMatchId(String matchId) {
    _scoreDetailsRepo = ScoreDetailsRepository(matchId);
    add(GetScoreDetails());
  }

  @override
  Stream<ScoreDetailsState> mapEventToState(ScoreDetailsEvent event) async* {
    if (event is GetScoreDetails) {
      yield ScoreDetailsFetching();
      final result = await _scoreDetailsRepo.getScoreDetails();
      if (result.data != null) {
        _score = result.data;
        yield ScoreDetailsFetchingSuccess(_score!);
      } else
        yield ScoreDetailsFetchingFailure(result.error);
    } else if (event is RefreshScoreDetails) {
      yield ScoreDetailsRefreshing(_score!);
      final result = await _scoreDetailsRepo.getScoreDetails();
      if (result.data != null) _score = result.data;
      yield ScoreDetailsFetchingSuccess(_score!);
    } else if (event is ResetScoreDetails) yield ScoreDetailsFetching();
  }
}
