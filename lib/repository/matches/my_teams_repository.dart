import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/models/models.dart';

class MyTeamsRepository {
  final String _matchId;

  MyTeamsRepository(this._matchId);

  Future<ApiResponse<MyTeam>> getMyTeams() async {
    try {
      final path = 'user/match-team/$_matchId';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(
          MyTeam.fromJson(json.decode(response.body)['data']));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the my teams');
    }
  }

  Future<ApiResponse<MatchPoint>> getMatchPoint() async {
    try {
      final path = 'match/$_matchId/point';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(
          MatchPoint.fromJson(json.decode(response.body)['data']));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get match point details');
    }
  }

  Future<ApiResponse<ImageData>> getTeamAndPlayerImages() async {
    try {
      final path = 'match/$_matchId/teamDetails';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(
          ImageData.fromJson(json.decode(response.body)['data']));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the team details');
    }
  }
}
