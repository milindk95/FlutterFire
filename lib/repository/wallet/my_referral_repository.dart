import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/models/models.dart';

class MyReferralRepository {
  Future<ApiResponse<List<MyReferral>>> getMyReferral() async {
    try {
      final path = 'user/myReferral/';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(List<MyReferral>.from(
          (json.decode(response.body)['data'] as List)
              .map((x) => MyReferral.fromJson(x))));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the referral');
    }
  }
}
