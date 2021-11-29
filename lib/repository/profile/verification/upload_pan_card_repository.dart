import 'dart:convert';

import 'package:the_super11/core/api/api_handler.dart';

class UploadPanCardRepository {
  Future<ApiResponse<String>> uploadPanCard(
      String panCardImagePath, Map<String, String> fields) async {
    try {
      final path = 'document/upload-pan-card';
      final response = await ApiHandler.multiPartRequest(
        methodType: 'POST',
        path: path,
        photoFilePath: panCardImagePath,
        photoField: 'panCardImage',
        fields: fields,
      );

      return ApiResponse.withSuccess(json.decode(response.body)['message'] ??
          'Pan card uploaded successfully');
    } on ApiException catch (e) {
      return ApiResponse.withError(e.message);
    } catch (e) {
      return ApiResponse.withError('Unable to upload your pan card');
    }
  }
}
