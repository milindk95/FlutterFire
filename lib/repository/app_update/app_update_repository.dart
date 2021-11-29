import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/models/models.dart';

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
