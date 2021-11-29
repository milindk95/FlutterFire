import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/repository/matches/my_matches_repository.dart';

part 'recent_matches_event.dart';

part 'recent_matches_state.dart';

class RecentMatchesBloc extends Bloc<RecentMatchesEvent, RecentMatchesState> {
  final MyMatchesRepository _myMatchesRepo = MyMatchesRepository();

  RecentMatchesBloc() : super(RecentMatchesFetching());

  @override
  Stream<RecentMatchesState> mapEventToState(RecentMatchesEvent event) async* {
    if (event is GetRecentMatches) {
      yield RecentMatchesFetching();
      final result = await _myMatchesRepo.getMyMatches(isAll: 0);
      if (result.data != null)
        yield RecentMatchesFetchingSuccess(result.data!);
      else
        yield RecentMatchesFetchingFailure(result.error);
    }
  }
}
