import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/core/preferences.dart';
import 'package:flutter_fire/core/utility.dart';

class LoginRepository {
  Future<ApiResponse<Map<String, dynamic>>> login(
      Map<String, dynamic> body) async {
    try {
      final path = 'auth/login';
      final deviceInfo =
          await Utility.getDeviceInfoJson(setNotificationToken: true);
      final response = await ApiHandler.post(path,
          body: body..addAll({'deviceInfo': deviceInfo}), allowLogOut: false);
      await Preference.setAuthToken(
          json.decode(response.body)['data']['token']);

      return ApiResponse.withSuccess(json.decode(response.body),
          statusCode: 200);
    } on ApiException catch (e) {
      return ApiResponse.withError(
        e.message,
        statusCode: e.response?.statusCode,
        data: e.response != null ? json.decode(e.response!.body) : null,
      );
    } catch (e) {
      return ApiResponse.withError('Unable to login to your account');
    }
  }
}
