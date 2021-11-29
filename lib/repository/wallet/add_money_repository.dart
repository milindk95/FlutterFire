import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/models/models.dart';

class AddMoneyRepository {
  Future<ApiResponse<RazorpayParams>> addMoney(
      Map<String, dynamic> payload) async {
    try {
      final path = 'user/add-money';
      final response = await ApiHandler.post(path, body: payload);

      return ApiResponse.withSuccess(
          RazorpayParams.fromJson(json.decode(response.body)['data']));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to add money');
    }
  }
}
