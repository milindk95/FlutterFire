import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';
import 'package:the_super11/models/models.dart';

class MatchCreditRepository {
  final String _matchId;

  MatchCreditRepository(this._matchId);

  Future<ApiResponse<MatchCredit>> getMatchCredit() async {
    try {
      final path = 'match/$_matchId/credit';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(
          MatchCredit.fromJson(json.decode(response.body)['data']));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the match credit');
    }
  }
}
