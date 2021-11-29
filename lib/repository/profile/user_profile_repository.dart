import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/models/models.dart';

class UserProfileRepository {
  Future<ApiResponse<User>> getProfile() async {
    try {
      final path = 'user';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(
          User.fromJson(json.decode(response.body)['data']));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get your profile data');
    }
  }
}
