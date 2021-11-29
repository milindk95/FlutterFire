import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/repository/profile/upload_photo_repository.dart';

part 'upload_photo_event.dart';

part 'upload_photo_state.dart';

class UploadPhotoBloc extends Bloc<UploadPhotoEvent, UploadPhotoState> {
  final UploadPhotoRepository _uploadPhotoRepo = UploadPhotoRepository();

  UploadPhotoBloc() : super(UploadPhotoInitial());

  @override
  Stream<UploadPhotoState> mapEventToState(UploadPhotoEvent event) async* {
    if (event is UploadProfilePhoto) {
      yield UploadPhotoProcessing();
      final result = await _uploadPhotoRepo.uploadPhoto(event.photoFilePath);
      if (result.data != null)
        yield UploadPhotoSuccess(
            result.data!['message'] ?? 'Profile photo uploaded successfully',
            result.data!['avatar'] ?? '');
      else
        yield UploadPhotoFailure(result.error);
    }
  }
}
