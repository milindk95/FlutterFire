import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';
import 'package:the_super11/models/models.dart';

class AccountsRepository {
  Future<ApiResponse<List<Account>>> getApprovedAccounts() async {
    try {
      final path = 'user/my-fund-accounts';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(List<Account>.from(
          (json.decode(response.body)['data'] as List)
              .map((x) => Account.fromJson(x))));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the transaction history');
    }
  }

  Future<ApiResponse<String>> requestForWithdraw(
      Map<String, String> body) async {
    try {
      final path = 'user/withdraw';
      final response = await ApiHandler.post(path, body: body);

      return ApiResponse.withSuccess(json.decode(response.body)['message'] ??
          'Withdraw request created successfully');
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the transaction history');
    }
  }
}
