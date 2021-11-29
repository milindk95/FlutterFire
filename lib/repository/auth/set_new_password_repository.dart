import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';

class SetNewPasswordRepository {
  Future<ApiResponse<String>> setNewPassword(Map<String, dynamic> body) async {
    try {
      final path = 'auth/verify-forgot-password';

      final response = await ApiHandler.post(path, body: body);

      return ApiResponse.withSuccess(json.decode(response.body)['message'] ??
          'Password reset successfully.');
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to set your new password');
    }
  }
}
