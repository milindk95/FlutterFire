import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';

class UploadPhotoRepository {
  Future<ApiResponse<Map<String, String>>> uploadPhoto(
      String photoFilePath) async {
    try {
      final path = 'user/avatar';
      final response = await ApiHandler.multiPartRequest(
        methodType: 'PUT',
        path: path,
        photoFilePath: photoFilePath,
        photoField: 'avatar',
      );

      final map = json.decode(response.body);
      return ApiResponse.withSuccess({
        'message': map['message'],
        'avatar': map['data'] != null ? map['data']['avatar'] ?? '' : ''
      });
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to edit your profile photo');
    }
  }
}
