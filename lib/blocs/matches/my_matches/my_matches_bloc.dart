import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/repository/matches/my_matches_repository.dart';

part 'my_matches_event.dart';

part 'my_matches_state.dart';

class MyMatchesBloc extends Bloc<MyMatchesEvent, MyMatchesState> {
  int _page = 1;
  List<MyMatch> _matches = [];
  final MyMatchesRepository _myMatchesRepo = MyMatchesRepository();

  MyMatchesBloc() : super(MyMatchesFetching());

  @override
  Stream<MyMatchesState> mapEventToState(MyMatchesEvent event) async* {
    if (event is GetMyMatches) {
      yield MyMatchesFetching();
      _page = 1;
      _matches.clear();
      final result = await _myMatchesRepo.getMyMatches(
          status: _getMatchStatus(event.index), pageNumber: _page);
      if (result.data != null) {
        _matches.addAll(result.data!);
        yield MyMatchesFetchingSuccess(_matches);
      } else
        yield MyMatchesFetchingFailure(result.error);
    }

    if (event is PagingMyMatches) {
      _page++;
      final result = await _myMatchesRepo.getMyMatches(
          status: _getMatchStatus(event.index), pageNumber: _page);
      if (result.data != null) {
        _matches.addAll(result.data!);
        yield MyMatchesFetchingSuccess(_matches,
            reachToMaxIndex: result.data!.isEmpty);
      } else {
        _page--;
        yield MyMatchesPagingError(_matches, result.error);
      }
    }

    if (event is RefreshMyMatches) {
      final result = await _myMatchesRepo.getMyMatches(
          status: _getMatchStatus(event.index), pageNumber: 1);
      if (result.data != null) {
        _page = 1;
        _matches.clear();
        _matches.addAll(result.data!);
        yield MyMatchesFetchingSuccess(_matches);
      } else
        yield MyMatchesRefreshingError(_matches, result.error);
    }
  }

  String _getMatchStatus(int index) {
    switch (index) {
      case 0:
        return 'upcoming';
      case 1:
        return 'live';
      case 2:
        return 'complete';
      default:
        return '';
    }
  }
}
