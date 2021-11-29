import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';

class EmailVerificationRepository {
  Future<ApiResponse<String>> sendEmailOTP() async {
    try {
      final path = 'user/verify-user-email';
      final response = await ApiHandler.post(path);

      return ApiResponse.withSuccess(
        json.decode(response.body)['message'] ?? '',
        statusCode: 200,
      );
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to send OTP in email');
    }
  }

  Future<ApiResponse<String>> verifyEmailOTP(Map<String, dynamic> body) async {
    try {
      final path = 'user/verify-email-otp';
      final response = await ApiHandler.post(path, body: body);

      return ApiResponse.withSuccess(
        json.decode(response.body)['message'] ?? '',
        statusCode: 200,
      );
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to verify your OTP');
    }
  }
}
