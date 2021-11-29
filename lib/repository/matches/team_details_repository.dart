import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';
import 'package:the_super11/models/models.dart';

class TeamDetailsRepository {
  Future<ApiResponse<Team>> getTeamDetails(String? teamId) async {
    try {
      final path = 'team/$teamId';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(
          Team.fromJson(json.decode(response.body)['data']));
    } catch (e) {
      return ApiResponse.withError('Unable to get the team details');
    }
  }
}
