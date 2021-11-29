part of 'upload_photo_bloc.dart';

abstract class UploadPhotoEvent extends Equatable {
  const UploadPhotoEvent();

  @override
  List<Object?> get props => [];
}

class UploadProfilePhoto extends UploadPhotoEvent {
  final String photoFilePath;

  UploadProfilePhoto(this.photoFilePath);
}
