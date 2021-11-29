import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/repository/contest/match_credit_repository.dart';

part 'match_credit_event.dart';
part 'match_credit_state.dart';

class MatchCreditBloc extends Bloc<MatchCreditEvent, MatchCreditState> {
  final String _matchId;
  late final MatchCreditRepository _matchCreditRepo;

  MatchCreditBloc(this._matchId) : super(MatchCreditInitial()) {
    _matchCreditRepo = MatchCreditRepository(_matchId);
  }

  @override
  Stream<MatchCreditState> mapEventToState(MatchCreditEvent event) async* {
    if (event is GetMatchCredit) {
      yield MatchCreditFetching();
      final result = await _matchCreditRepo.getMatchCredit();
      if (result.data != null)
        yield MatchCreditFetchingSuccess(result.data!);
      else
        yield MatchCreditFetchingFailure(result.error);
    }
  }
}
