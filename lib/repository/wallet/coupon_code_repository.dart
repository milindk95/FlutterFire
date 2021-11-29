import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/models/models.dart';

class CouponCodeRepository {
  Future<ApiResponse<Coupon>> applyCouponCode(Map<String, dynamic> body) async {
    try {
      final path = 'offer/applyCode';
      final response = await ApiHandler.post(path, body: body);

      return ApiResponse.withSuccess(
        Coupon.fromJson(json.decode(response.body)['data']),
        message: json.decode(response.body)['message'],
      );
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to apply the offer');
    }
  }
}
