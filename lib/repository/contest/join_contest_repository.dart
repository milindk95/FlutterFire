import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';

class JoinContestRepository {
  Future<ApiResponse<String>> joinContest(Map<String, dynamic> body) async {
    try {
      final path = 'user/contest/';
      final response = await ApiHandler.post(path, body: body);

      return ApiResponse.withSuccess(json.decode(response.body)['message'] ??
          'Contest joined successfully');
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to join the contest');
    }
  }

  Future<ApiResponse<String>> joinPrivateContest(
      String contestCode, Map<String, dynamic> body) async {
    try {
      final path = 'user/contest/$contestCode';
      final response = await ApiHandler.post(path, body: body);

      return ApiResponse.withSuccess(json.decode(response.body)['message'] ??
          'Contest joined successfully');
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to join the contest');
    }
  }
}
