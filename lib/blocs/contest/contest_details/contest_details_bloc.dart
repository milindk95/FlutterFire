import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/repository/contest/contest_details_repository.dart';

part 'contest_details_event.dart';
part 'contest_details_state.dart';

class ContestDetailsBloc
    extends Bloc<ContestDetailsEvent, ContestDetailsState> {
  final String _contestId;
  late final ContestDetailsRepository _contestDetailsRepo;

  ContestDetailsBloc(this._contestId) : super(ContestDetailsInitial()) {
    _contestDetailsRepo = ContestDetailsRepository(_contestId);
  }

  @override
  Stream<ContestDetailsState> mapEventToState(
      ContestDetailsEvent event) async* {
    if (event is GetContestDetails) {
      yield ContestDetailsFetching();
      final result = await _contestDetailsRepo.getContestDetails();
      if (result.data != null)
        yield ContestDetailsFetchingSuccess(result.data!);
      else
        yield ContestDetailsFetchingFailure(result.error);
    }
  }
}
