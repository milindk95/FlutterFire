import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';
import 'package:the_super11/models/models.dart';

class JoinedContestsRepository {
  final String _matchId;

  JoinedContestsRepository(this._matchId);

  Future<ApiResponse<List<Contest>>> getJoinedContests(
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
      return ApiResponse.withError('Unable to get the joined contests');
    }
  }
}
