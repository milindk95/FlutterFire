import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';

class EditProfileRepository {
  Future<ApiResponse<String>> editProfile(Map<String, dynamic> payload) async {
    try {
      final path = 'user';
      final response = await ApiHandler.put(path, body: payload);

      return ApiResponse.withSuccess(json.decode(response.body)['message'] ??
          'Profile updated successfully');
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to edit your profile');
    }
  }
}
