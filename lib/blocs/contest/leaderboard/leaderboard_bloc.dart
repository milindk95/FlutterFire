import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/repository/contest/leaderboard_repository.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final String _contestId;
  int _page = 1;
  List<ContestParticipation> _participants = [];
  late final _totalParticipants;
  late final LeaderboardRepository _leaderboardRepo;

  LeaderboardBloc(this._contestId) : super(LeaderboardFetching()) {
    _leaderboardRepo = LeaderboardRepository(_contestId);
  }

  @override
  Stream<LeaderboardState> mapEventToState(LeaderboardEvent event) async* {
    if (event is GetLeaderboard) {
      yield LeaderboardFetching();
      _page = 1;
      final result = await _leaderboardRepo.getLeaderboard(pageNumber: _page);
      if (result.data != null) {
        _participants.clear();
        _participants.addAll(result.data!.participants);
        _totalParticipants = result.data!.totalContestParticipants;
        yield LeaderboardFetchingSuccess(
          participants: _participants,
          totalParticipants: _totalParticipants,
        );
      } else
        yield LeaderboardFetchingFailure(result.error);
    }

    if (event is PagingLeaderboard) {
      _page++;
      final result = await _leaderboardRepo.getLeaderboard(pageNumber: _page);
      if (result.data != null) {
        _participants.addAll(result.data!.participants);
        yield LeaderboardFetchingSuccess(
          participants: _participants,
          totalParticipants: _totalParticipants,
          reachToMaxIndex: result.data!.participants.isEmpty,
        );
      } else {
        _page--;
        yield LeaderboardPagingError(
          participants: _participants,
          totalParticipants: _totalParticipants,
          error: result.error,
        );
      }
    }

    if (event is RefreshLeaderboard) {
      final result = await _leaderboardRepo.getLeaderboard(pageNumber: 1);
      if (result.data != null) {
        _page = 1;
        _participants.clear();
        _participants.addAll(result.data!.participants);
        yield LeaderboardFetchingSuccess(
          participants: _participants,
          totalParticipants: _totalParticipants,
        );
      } else
        yield LeaderboardRefreshingError(
          participants: _participants,
          totalParticipants: _totalParticipants,
          error: result.error,
        );
    }
  }
}
