import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_super11/repository/contest/join_contest_repository.dart';

part 'join_contest_event.dart';
part 'join_contest_state.dart';

class JoinContestBloc extends Bloc<JoinContestEvent, JoinContestState> {
  JoinContestBloc() : super(JoinContestInitial());
  final _contestRepo = JoinContestRepository();

  @override
  Stream<JoinContestState> mapEventToState(JoinContestEvent event) async* {
    if (event is JoinContest) {
      yield JoinContestInProgress();
      final result = await _contestRepo.joinContest(event.body);
      if (result.data != null)
        yield JoinContestSuccess(result.data!);
      else
        yield JoinContestFailure(result.error);
    }
  }
}
