import 'dart:convert';

import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/models/models.dart';

class UserAccountsRepository {
  Future<ApiResponse<List<UserAccount>>> getAllAccounts() async {
    try {
      final path = 'user/all-documents';
      final response = await ApiHandler.get(path);

      return ApiResponse.withSuccess(List<UserAccount>.from(
          (json.decode(response.body)['data'] as List)
              .map((x) => UserAccount.fromJson(x))));
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to get user accounts');
    }
  }

  Future<ApiResponse<String>> addBankAccount(
      {required String photoFilePath,
      required Map<String, String> fields}) async {
    try {
      final path = 'document/upload-bank-passbook';
      final response = await ApiHandler.multiPartRequest(
        methodType: 'POST',
        path: path,
        photoField: 'passbookImage',
        photoFilePath: photoFilePath,
        fields: fields,
      );

      return ApiResponse.withSuccess(json.decode(response.body)['message'] ??
          'Bank Account added successfully.');
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to add Bank Account');
    }
  }

  Future<ApiResponse<String>> addUPIAccount(Map<String, String> body) async {
    try {
      final path = 'document/upload-bank-passbook';
      final response = await ApiHandler.post(path, body: body);

      return ApiResponse.withSuccess(json.decode(response.body)['message'] ??
          'UPI Account added successfully.');
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to add UPI Account');
    }
  }
}
