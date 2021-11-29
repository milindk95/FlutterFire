part of 'image_data_bloc.dart';

abstract class ImageDataState extends Equatable {
  const ImageDataState();

  @override
  List<Object> get props => [];
}

class ImageDataFetching extends ImageDataState {}

class ImageDataFetchingSuccess extends ImageDataState {
  final ImageData imageData;

  ImageDataFetchingSuccess(this.imageData);
}

class ImageDataFetchingFailure extends ImageDataState {
  final String error;

  ImageDataFetchingFailure(this.error);

  @override
  List<Object> get props => [error];
}
