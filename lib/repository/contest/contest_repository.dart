import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';
import 'package:the_super11/models/models.dart';

class ContestRepository {
  final String _matchId;

  ContestRepository(this._matchId);

  Future<ApiResponse<ContestData>> getContests() async {
    try {
      final path = 'match/$_matchId/contest';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(
          ContestData.fromJson(json.decode(response.body)['data']));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the contests');
    }
  }

  Future<ApiResponse<List<Contest>>> getUserContests(
      {int pageNumber = 1}) async {
    try {
      final path = 'user/match/$_matchId/contest?page=$pageNumber';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(List<Contest>.from(
          (json.decode(response.body)['data'] as List)
              .map((x) => Contest.fromJson(x))));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the contests');
    }
  }

  Future<ApiResponse<String>> createContest(Map<String, dynamic> body) async {
    try {
      final path = 'match/$_matchId/contest';
      final response = await ApiHandler.post(path, body: body);

      return ApiResponse.withSuccess(json.decode(response.body)['message'] ??
          'Contest created successfully');
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to create the contest');
    }
  }
}
