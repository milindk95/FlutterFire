import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/resources/resources.dart';

class MyMatchesRepository {
  Future<ApiResponse<List<MyMatch>>> getMyMatches({
    int isAll = 1,
    String status = '',
    int pageNumber = 1,
  }) async {
    try {
      late final path;
      if (status.isEmpty)
        path = 'user/match?isAll=$isAll';
      else
        path = 'user/match?isAll=$isAll&status=$status&page=$pageNumber';
      final response = await ApiHandler.get(path);

      final matches = List<MyMatch>.from(
          (json.decode(response.body)['data'] as List)
              .map((x) => MyMatch.fromJson(x)));
      matches.removeWhere((match) =>
          DateTime.parse(match.startDate).toLocal().compareTo(DateTime.now()) <
              0 &&
          match.status == matchNotStarted);
      return ApiResponse.withSuccess(matches);
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the matches');
    }
  }
}
