import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/models/models.dart';

class LeaderboardRepository {
  final String _contestId;

  LeaderboardRepository(this._contestId);

  Future<ApiResponse<Leaderboard>> getLeaderboard({int pageNumber = 1}) async {
    try {
      final path = 'contest/$_contestId/leaderBoard?page=$pageNumber';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(
        Leaderboard.fromJson(json.decode(response.body)['data']),
      );
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the leaderboard');
    }
  }
}
