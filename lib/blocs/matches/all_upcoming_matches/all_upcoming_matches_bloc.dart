import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/repository/matches/all_upcoming_matches_repository.dart';

part 'all_upcoming_matches_event.dart';
part 'all_upcoming_matches_state.dart';

class AllUpcomingMatchesBloc
    extends Bloc<AllUpcomingMatchesEvent, AllUpcomingMatchesState> {
  int _page = 1;
  List<MyMatch> _matches = [];
  final _upcomingMatchesRepo = AllUpcomingMatchesRepository();

  AllUpcomingMatchesBloc() : super(AllUpcomingMatchesFetching());

  @override
  Stream<AllUpcomingMatchesState> mapEventToState(
      AllUpcomingMatchesEvent event) async* {
    if (event is GetAllUpcomingMatches) {
      yield AllUpcomingMatchesFetching();
      _page = 1;
      _matches.clear();
      final result =
          await _upcomingMatchesRepo.getAllUpcomingMatches(pageNumber: _page);
      if (result.data != null) {
        _matches.addAll(result.data!);
        yield AllUpcomingMatchesFetchingSuccess(_matches);
      } else
        yield AllUpcomingMatchesFetchingFailure(result.error);
    }

    if (event is PagingAllUpcomingMatches) {
      _page++;
      final result =
          await _upcomingMatchesRepo.getAllUpcomingMatches(pageNumber: _page);
      if (result.data != null) {
        _matches.addAll(result.data!);
        yield AllUpcomingMatchesFetchingSuccess(_matches,
            reachToMaxIndex: result.data!.isEmpty);
      } else {
        _page--;
        yield AllUpcomingMatchesPagingError(_matches, result.error);
      }
    }

    if (event is RefreshAllUpcomingMatches) {
      final result =
          await _upcomingMatchesRepo.getAllUpcomingMatches(pageNumber: 1);
      if (result.data != null) {
        _page = 1;
        _matches.clear();
        _matches.addAll(result.data!);
        yield AllUpcomingMatchesFetchingSuccess(_matches);
      } else
        yield AllUpcomingMatchesRefreshingError(_matches, result.error);
    }
  }
}
