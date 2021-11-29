import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';
import 'package:the_super11/models/models.dart';

class ScoreDetailsRepository {
  final String _matchId;

  ScoreDetailsRepository(this._matchId);

  Future<ApiResponse<Score>> getScoreDetails() async {
    try {
      final path = 'match/$_matchId/score';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(
          Score.fromJson(json.decode(response.body)['data']));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the score');
    }
  }
}
