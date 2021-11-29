import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/repository/contest/contest_repository.dart';

part 'all_contests_event.dart';
part 'all_contests_state.dart';

class AllContestsBloc extends Bloc<AllContestsEvent, AllContestsState> {
  late ContestRepository _contestRepo;
  ContestData? _contestData;

  AllContestsBloc() : super(AllContestsFetching());

  void setMatchId(String matchId) {
    _contestRepo = ContestRepository(matchId);
    add(GetAllContests());
  }

  @override
  Stream<AllContestsState> mapEventToState(AllContestsEvent event) async* {
    if (event is GetAllContests) {
      yield AllContestsFetching();
      final result = await _contestRepo.getContests();
      if (result.data != null) {
        _contestData = result.data;
        yield AllContestsFetchingSuccess(_contestData!);
      } else
        yield AllContestsFetchingFailure(result.error);
    } else if (event is RefreshAllContests) {
      final result = await _contestRepo.getContests();
      if (result.data != null) {
        _contestData = result.data;
        yield AllContestsFetchingSuccess(_contestData!);
      } else
        yield AllContestsRefreshingError(_contestData!, result.error);
    } else if (event is ResetAllContests) yield AllContestsFetching();
  }
}
