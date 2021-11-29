import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';

class CreateUpdateTeamRepository {
  Future<ApiResponse<String>> createTeam(Map<String, dynamic> body) async {
    try {
      final path = 'user/team';
      final response = await ApiHandler.post(path, body: body);

      return ApiResponse.withSuccess(
          json.decode(response.body)['message'] ?? 'Add Team successfully.');
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to create team');
    }
  }

  Future<ApiResponse<String>> updateTeam(
      String teamId, Map<String, dynamic> body) async {
    try {
      final path = 'user/team/$teamId';
      final response = await ApiHandler.put(path, body: body);

      return ApiResponse.withSuccess(
          json.decode(response.body)['message'] ?? 'Update Team successfully.');
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to update team');
    }
  }
}
