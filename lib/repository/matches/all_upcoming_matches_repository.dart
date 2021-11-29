import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';
import 'package:the_super11/models/models.dart';

class AllUpcomingMatchesRepository {
  Future<ApiResponse<List<MyMatch>>> getAllUpcomingMatches(
      {int pageNumber = 1}) async {
    try {
      final path = 'match?page=$pageNumber';
      final response = await ApiHandler.get(path);

      final matches = List<MyMatch>.from(
          (json.decode(response.body)['data'] as List)
              .map((x) => MyMatch.fromJson(x)));
      matches.removeWhere((match) =>
          DateTime.parse(match.startDate).toLocal().compareTo(DateTime.now()) <
          0);
      return ApiResponse.withSuccess(matches);
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the matches');
    }
  }
}
