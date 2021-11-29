import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/core/utility.dart';
import 'package:flutter_fire/models/models.dart';

class SignUpRepository {
  Future<ApiResponse<User>> signUp(Map<String, dynamic> body) async {
    try {
      final path = 'auth/registration';
      final deviceInfo = await Utility.getDeviceInfoJson(
          setNotificationToken: true, setIpAddress: false);
      final response = await ApiHandler.post(path,
          body: body..addAll({'deviceInfo': deviceInfo}), allowLogOut: false);

      return ApiResponse.withSuccess(
          User.fromJson(json.decode(response.body)['data']));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to sign up your account.');
    }
  }
}
