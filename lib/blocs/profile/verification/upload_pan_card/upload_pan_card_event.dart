part of 'upload_pan_card_bloc.dart';

abstract class UploadPanCardEvent extends Equatable {
  const UploadPanCardEvent();

  @override
  List<Object?> get props => [];
}

class UploadPanCard extends UploadPanCardEvent {
  final String panCardImagePath;
  final String panCardName;
  final String panCardNumber;

  UploadPanCard({
    required this.panCardImagePath,
    required this.panCardName,
    required this.panCardNumber,
  });
}
