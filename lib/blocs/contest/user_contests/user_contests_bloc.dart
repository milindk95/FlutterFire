import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/repository/contest/contest_repository.dart';

part 'user_contests_event.dart';
part 'user_contests_state.dart';

class UserContestsBloc extends Bloc<UserContestsEvent, UserContestsState> {
  late ContestRepository _contestRepo;
  int _page = 1;
  List<Contest> _contests = [];

  UserContestsBloc() : super(UserContestsFetching());

  void setMatchId(String matchId) {
    _contestRepo = ContestRepository(matchId);
    add(GetUserContests());
  }

  @override
  Stream<UserContestsState> mapEventToState(UserContestsEvent event) async* {
    if (event is GetUserContests) {
      yield UserContestsFetching();
      _page = 1;
      _contests.clear();
      final result = await _contestRepo.getUserContests(pageNumber: _page);
      if (result.data != null) {
        _contests.addAll(result.data!);
        yield UserContestsFetchingSuccess(_contests);
      } else
        yield UserContestsFetchingFailure(result.error);
    }

    if (event is PagingUserContests) {
      _page++;
      final result = await _contestRepo.getUserContests(pageNumber: _page);
      if (result.data != null) {
        _contests.addAll(result.data!);
        yield UserContestsFetchingSuccess(_contests,
            reachToMaxIndex: result.data!.isEmpty);
      } else {
        _page--;
        yield UserContestsPagingError(_contests, result.error);
      }
    }

    if (event is RefreshUserContests) {
      final result = await _contestRepo.getUserContests(pageNumber: 1);
      if (result.data != null) {
        _page = 1;
        _contests.clear();
        _contests.addAll(result.data!);
        yield UserContestsFetchingSuccess(_contests);
      } else
        yield UserContestsRefreshingError(_contests, result.error);
    }

    if (event is ResetUserContests) yield UserContestsFetching();
  }
}
