part of 'image_data_bloc.dart';

abstract class ImageDataEvent extends Equatable {
  const ImageDataEvent();

  @override
  List<Object?> get props => [];
}

class GetImageData extends ImageDataEvent {}

class ResetImageData extends ImageDataEvent {}
