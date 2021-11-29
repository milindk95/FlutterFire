import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';
import 'package:the_super11/models/models.dart';

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
