import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/repository/contest/join_contest_repository.dart';

part 'join_private_contest_event.dart';
part 'join_private_contest_state.dart';

class JoinPrivateContestBloc
    extends Bloc<JoinPrivateContestEvent, JoinPrivateContestState> {
  final _contestRepo = JoinContestRepository();

  JoinPrivateContestBloc() : super(JoinPrivateContestInitial());

  @override
  Stream<JoinPrivateContestState> mapEventToState(
      JoinPrivateContestEvent event) async* {
    if (event is JoinPrivateContest) {
      yield JoinPrivateContestInProgress();
      final result =
          await _contestRepo.joinPrivateContest(event.contestCode, event.body);
      if (result.data != null)
        yield JoinPrivateContestSuccess(result.data!);
      else
        yield JoinPrivateContestFailure(result.error);
    }
  }
}
