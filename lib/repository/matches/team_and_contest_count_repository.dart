import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';

class TeamAndContestCountRepository {
  final String _matchId;

  TeamAndContestCountRepository(this._matchId);

  Future<ApiResponse<Map<String, int>>> getTeamAndContestCount() async {
    try {
      final path = 'user/match/$_matchId/counts';
      final response = await ApiHandler.get(path);

      final map = json.decode(response.body)['data'] as Map<String, dynamic>;
      return ApiResponse.withSuccess(
          {'team': map['team'], 'contest': map['contest']});
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the score');
    }
  }
}
