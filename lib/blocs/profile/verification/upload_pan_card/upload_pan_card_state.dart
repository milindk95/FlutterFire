part of 'upload_pan_card_bloc.dart';

abstract class UploadPanCardState extends Equatable {
  const UploadPanCardState();

  @override
  List<Object> get props => [];
}

class UploadPanCardInitial extends UploadPanCardState {}

class UploadPanCardInProgress extends UploadPanCardState {}

class UploadPanCardSuccess extends UploadPanCardState {
  final String message;

  UploadPanCardSuccess(this.message);
}

class UploadPanCardFailure extends UploadPanCardState {
  final String error;

  UploadPanCardFailure(this.error);
}
