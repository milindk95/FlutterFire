import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/repository/matches/joined_contests_repository.dart';

part 'joined_contests_event.dart';
part 'joined_contests_state.dart';

class JoinedContestsBloc
    extends Bloc<JoinedContestsEvent, JoinedContestsState> {
  final String _matchId;
  late final JoinedContestsRepository _joinedContestsRepo;
  int _page = 1;
  List<Contest> _contests = [];

  JoinedContestsBloc(this._matchId) : super(JoinedContestsFetching()) {
    _joinedContestsRepo = JoinedContestsRepository(_matchId);
  }

  @override
  Stream<JoinedContestsState> mapEventToState(
      JoinedContestsEvent event) async* {
    if (event is GetJoinedContests) {
      yield JoinedContestsFetching();
      _page = 1;
      _contests.clear();
      final result =
          await _joinedContestsRepo.getJoinedContests(pageNumber: _page);
      if (result.data != null) {
        _contests.addAll(result.data!);
        yield JoinedContestsFetchingSuccess(_contests);
      } else
        yield JoinedContestsFetchingFailure(result.error);
    }

    if (event is PagingJoinedContests) {
      _page++;
      final result =
          await _joinedContestsRepo.getJoinedContests(pageNumber: _page);
      if (result.data != null) {
        _contests.addAll(result.data!);
        yield JoinedContestsFetchingSuccess(_contests,
            reachToMaxIndex: result.data!.isEmpty);
      } else {
        _page--;
        yield JoinedContestsPagingError(_contests, result.error);
      }
    }

    if (event is RefreshJoinedContests) {
      final result = await _joinedContestsRepo.getJoinedContests(pageNumber: 1);
      if (result.data != null) {
        _page = 1;
        _contests.clear();
        _contests.addAll(result.data!);
        yield JoinedContestsFetchingSuccess(_contests);
      } else
        yield JoinedContestsRefreshingError(_contests, result.error);
    }
  }
}
