import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';
import 'package:the_super11/models/models.dart';

class AppUpdateRepository {
  Future<ApiResponse<AppUpdate>> checkAppUpdate() async {
    try {
      final path = 'version';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(
          AppUpdate.fromJson(json.decode(response.body)['data']));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to connect to the server.');
    }
  }
}
