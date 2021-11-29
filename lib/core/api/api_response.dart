part of 'api_handler.dart';

/// Common class for API response
class ApiResponse<T> {
  final T? data;
  final int? statusCode;
  final String error;
  final String successMessage;

  ApiResponse({
    this.data,
    this.statusCode,
    this.successMessage = '',
    this.error = '',
  });

  factory ApiResponse.withSuccess(
    T data, {
    String message = '',
    int? statusCode,
  }) =>
      ApiResponse<T>(
        data: data,
        successMessage: message,
        statusCode: statusCode,
      );

  factory ApiResponse.withError(
    String error, {
    int? statusCode,
    T? data,
  }) =>
      ApiResponse<T>(
        error: error,
        statusCode: statusCode,
        data: data,
      );
}
