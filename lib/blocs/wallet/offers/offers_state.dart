part of 'offers_bloc.dart';

abstract class OffersState extends Equatable {
  const OffersState();

  @override
  List<Object> get props => [];
}

class OffersFetching extends OffersState {}

class OffersFetchingSuccess extends OffersState {
  final List<Offer> offers;

  OffersFetchingSuccess(this.offers);
}

class OffersFetchingFailure extends OffersState {
  final String error;

  OffersFetchingFailure(this.error);
}
