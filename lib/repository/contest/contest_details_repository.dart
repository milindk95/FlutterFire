import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/models/models.dart';

class ContestDetailsRepository {
  final String _contestId;

  ContestDetailsRepository(this._contestId);

  Future<ApiResponse<Contest>> getContestDetails() async {
    try {
      final path = 'contest/$_contestId';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(
          Contest.fromJson(json.decode(response.body)['data']));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the contest details');
    }
  }
}
