import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/repository/wallet/offer_repository.dart';

part 'offers_event.dart';

part 'offers_state.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  final _offerRepo = OfferRepository();

  OffersBloc() : super(OffersFetching());

  @override
  Stream<OffersState> mapEventToState(OffersEvent event) async* {
    if (event is GetOffers) {
      yield OffersFetching();
      final result = await _offerRepo.getOffers();
      if (result.data != null)
        yield OffersFetchingSuccess(result.data!);
      else
        yield OffersFetchingFailure(result.error);
    }
  }
}
