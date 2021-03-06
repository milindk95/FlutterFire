import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/models/models.dart';

class OfferRepository {
  Future<ApiResponse<List<Offer>>> getOffers() async {
    try {
      final path = 'offer/';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(List<Offer>.from(
          (json.decode(response.body)['data'] as List)
              .map((x) => Offer.fromJson(x))));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the offers');
    }
  }
}
