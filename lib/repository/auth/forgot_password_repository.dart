import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';
import 'package:the_super11/core/utility.dart';

class ForgotPasswordRepository {
  Future<ApiResponse<Map<String, String>>> forgotPassword(
      Map<String, dynamic> body) async {
    try {
      final path = 'auth/forgot-password';
      final deviceInfo = await Utility.getDeviceInfoJson();
      final response = await ApiHandler.post(path,
          body: body..addAll({'deviceInfo': deviceInfo}));

      final map = json.decode(response.body)['data'] as Map;

      return ApiResponse.withSuccess({
        'userId': map['user'],
        'forgotPasswordId': map['_id'],
      });
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to process for forgot password');
    }
  }
}
