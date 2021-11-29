import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';
import 'package:the_super11/models/models.dart';

class TransactionHistoryRepository {
  Future<ApiResponse<List<TransactionHistory>>> getTransactionHistories({
    String status = 'All',
    int pageNumber = 1,
  }) async {
    try {
      final path =
          'walletTransactionHistory/?transactionType=$status&page=$pageNumber';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(List<TransactionHistory>.from(
          (json.decode(response.body)['data'] as List)
              .map((x) => TransactionHistory.fromJson(x))));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get the transaction history');
    }
  }
}
