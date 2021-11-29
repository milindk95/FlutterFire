import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_super11/repository/profile/verification/upload_pan_card_repository.dart';

part 'upload_pan_card_event.dart';
part 'upload_pan_card_state.dart';

class UploadPanCardBloc extends Bloc<UploadPanCardEvent, UploadPanCardState> {
  final _panCardRepo = UploadPanCardRepository();

  UploadPanCardBloc() : super(UploadPanCardInitial());

  @override
  Stream<UploadPanCardState> mapEventToState(UploadPanCardEvent event) async* {
    if (event is UploadPanCard) {
      yield UploadPanCardInProgress();
      final result = await _panCardRepo.uploadPanCard(
        event.panCardImagePath,
        {
          'panCardUsername': event.panCardName,
          'panCardNumber': event.panCardNumber,
        },
      );
      if (result.data != null)
        yield UploadPanCardSuccess(result.data!);
      else
        yield UploadPanCardFailure(result.error);
    }
  }
}
