import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';
import 'package:the_super11/models/models.dart';

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
