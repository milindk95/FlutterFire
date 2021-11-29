import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/repository/matches/my_teams_repository.dart';

part 'image_data_event.dart';
part 'image_data_state.dart';

class ImageDataBloc extends Bloc<ImageDataEvent, ImageDataState> {
  late MyTeamsRepository _myTeamsRepo;

  ImageDataBloc() : super(ImageDataFetching());

  void setMatchId(String matchId) {
    _myTeamsRepo = MyTeamsRepository(matchId);
    add(GetImageData());
  }

  @override
  Stream<ImageDataState> mapEventToState(ImageDataEvent event) async* {
    if (event is GetImageData) {
      yield ImageDataFetching();
      final result = await _myTeamsRepo.getTeamAndPlayerImages();
      if (result.data != null)
        yield ImageDataFetchingSuccess(result.data!);
      else
        yield ImageDataFetchingFailure(result.error);
    } else if (event is ResetImageData) {
      yield ImageDataFetching();
    }
  }
}
