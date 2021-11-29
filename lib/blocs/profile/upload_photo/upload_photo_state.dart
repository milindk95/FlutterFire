part of 'upload_photo_bloc.dart';

abstract class UploadPhotoState extends Equatable {
  const UploadPhotoState();

  @override
  List<Object> get props => [];
}

class UploadPhotoInitial extends UploadPhotoState {}

class UploadPhotoProcessing extends UploadPhotoState {}

class UploadPhotoSuccess extends UploadPhotoState {
  final String message;
  final String avatar;

  UploadPhotoSuccess(this.message, this.avatar);
}

class UploadPhotoFailure extends UploadPhotoState {
  final String error;

  UploadPhotoFailure(this.error);
}
