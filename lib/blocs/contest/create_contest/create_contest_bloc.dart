import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/repository/contest/contest_repository.dart';

part 'create_contest_event.dart';
part 'create_contest_state.dart';

class CreateContestBloc extends Bloc<CreateContestEvent, CreateContestState> {
  late ContestRepository _contestRepo;

  CreateContestBloc() : super(CreateContestInitial());

  void setMatchId(String matchId) {
    _contestRepo = ContestRepository(matchId);
  }

  @override
  Stream<CreateContestState> mapEventToState(CreateContestEvent event) async* {
    if (event is CreateContest) {
      yield CreateContestInProgress();
      final result = await _contestRepo.createContest(event.body);
      if (result.data != null)
        yield CreateContestSuccess(result.data!);
      else
        yield CreateContestFailure(result.error);
    } else if (event is ResetCreateContest) yield CreateContestInitial();
  }
}
