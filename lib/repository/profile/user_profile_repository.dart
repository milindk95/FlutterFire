import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';
import 'package:the_super11/models/models.dart';

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
