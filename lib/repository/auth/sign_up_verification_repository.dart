import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/core/preferences.dart';
import 'package:flutter_fire/models/models.dart';

class SignUpVerificationRepository {
  Future<ApiResponse<User>> signUpVerification(
      Map<String, dynamic> body) async {
    try {
      final path = 'auth/verify-registration';

      final response = await ApiHandler.post(path, body: body);

      await Preference.setAuthToken(
          json.decode(response.body)['data']?['token'] ?? '');

      return ApiResponse.withSuccess(
        User.fromJson(json.decode(response.body)['data']),
        message: json.decode(response.body)['data']?['message'] ??
            'Mobile number is verified successfully.',
      );
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to verify your account.');
    }
  }
}
