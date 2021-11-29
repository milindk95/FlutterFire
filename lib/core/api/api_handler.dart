import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:the_super11/core/preferences.dart';
import 'package:the_super11/core/utility.dart';
import 'package:the_super11/main.dart';
import 'package:the_super11/ui/screens/auth/login_sign_up_screen.dart';

part 'api_response.dart';

class ApiHandler {
  static late final _baseUrl;

  static setBaseUrl(String url) => _baseUrl = url;

  /// API GET method
  static Future<Response> get(String path) async {
    try {
      log('----------------------------------------------------------------');
      log('GET: ' + _baseUrl + path);
      final headers = await _getHeaders();
      log('Headers: $headers');
      log('----------------------------------------------------------------');
      final response = await Client()
          .get(Uri.parse(_baseUrl + path), headers: headers)
          .timeout(const Duration(seconds: 60));
      log('STATUS : ${response.statusCode}');
      log('----------------------------------------------------------------');
      log(response.body);
      log('----------------------------------------------------------------');
      return getResponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeoutException();
    } on FormatException {
      throw GeneralException();
    }
  }

  /// API POST method
  static Future<Response> post(String url,
      {Object? body, bool allowLogOut = true}) async {
    try {
      log('----------------------------------------------------------------');
      log('POST: ' + _baseUrl + url);
      final headers = await _getHeaders();
      log('Headers: $headers');
      if (body != null) log('Body: ${json.encode(body)}');
      log('----------------------------------------------------------------');
      final response = await Client()
          .post(Uri.parse(_baseUrl + url),
              body: body != null ? json.encode(body) : null, headers: headers)
          .timeout(const Duration(seconds: 60));
      log('STATUS : ${response.statusCode}');
      log('----------------------------------------------------------------');
      log(response.body);
      log('----------------------------------------------------------------');
      return getResponse(response, allowLogOut: allowLogOut);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeoutException();
    } on FormatException {
      throw GeneralException();
    }
  }

  /// API PUT method
  static Future<Response> put(String url, {Object? body}) async {
    try {
      log('----------------------------------------------------------------');
      log('PUT: ' + _baseUrl + url);
      final headers = await _getHeaders();
      log('Headers: $headers');
      if (body != null) log('Body: ${json.encode(body)}');
      log('----------------------------------------------------------------');
      final response = await Client()
          .put(Uri.parse(_baseUrl + url),
              body: body != null ? json.encode(body) : null, headers: headers)
          .timeout(const Duration(seconds: 60));
      log('STATUS : ${response.statusCode}');
      log('----------------------------------------------------------------');
      log(response.body);
      log('----------------------------------------------------------------');
      return getResponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeoutException();
    } on FormatException {
      throw GeneralException();
    }
  }

  /// API Multipart request method
  static Future<Response> multiPartRequest({
    required String methodType,
    required String path,
    required String photoFilePath,
    required String photoField,
    Map<String, String>? fields,
  }) async {
    try {
      log('----------------------------------------------------------------');
      log('MULTIPART: $methodType' + _baseUrl + path);
      final headers = await _getHeaders();
      log('Headers: $headers');
      log('----------------------------------------------------------------');
      final request = MultipartRequest(methodType, Uri.parse(_baseUrl + path));

      request.files.add(await MultipartFile.fromPath(photoField, photoFilePath,
          contentType: MediaType('image', 'jpg')));
      if (fields != null && fields.isNotEmpty)
        fields.forEach((key, value) => request.fields[key] = value);
      request.headers.addAll(headers);

      final streamResponse = await request.send();
      final response = await Response.fromStream(streamResponse)
          .timeout(const Duration(seconds: 60));

      log('STATUS : ${response.statusCode}');
      log('----------------------------------------------------------------');
      log(response.body);
      log('----------------------------------------------------------------');
      return getResponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeoutException();
    } on FormatException {
      throw GeneralException();
    }
  }

  static Future<Map<String, String>> _getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    final userPref = await Preference.getUserData();
    final deviceId = await Utility.getDeviceId();
    headers.addAll({'deviceID': deviceId});
    if (userPref != null) {
      final authToken = await Preference.getAuthToken();
      headers.addAll({'authorization': authToken});
    }
    return headers;
  }
}

/// Function that handle response by status code
Response getResponse(Response response, {bool allowLogOut = true}) {
  switch (response.statusCode) {
    case 200:
      return response;

    case 400:
      if (allowLogOut) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          LoginSignUpScreen.route,
          (route) => false,
        );
        Preference.clearUserData();
      }
      throw BadRequestException(response);

    case 404:
      throw DataNotFoundException(response);

    default:
      throw InvalidDataException(response);
  }
}

/// General class for API call exception
class ApiException implements Exception {
  final String message;
  final Response? response;

  ApiException({required this.message, this.response});
}

/// Internet exception
class InternetException extends ApiException {
  InternetException() : super(message: 'No active internet connection');
}

/// Request timeout exception
class RequestTimeoutException extends ApiException {
  RequestTimeoutException() : super(message: 'Request timeout');
}

/// General exception
class GeneralException extends ApiException {
  GeneralException() : super(message: 'Something went wrong');
}

/// Bad request exception {400}
class BadRequestException extends ApiException {
  final Response response;

  BadRequestException(this.response)
      : super(
            message: 'You are signed out. please login again',
            response: response);
}

/// Data not found exception {404}
class DataNotFoundException extends ApiException {
  final Response response;

  DataNotFoundException(this.response)
      : super(
            message: json.decode(response.body)['message'] ??
                'Requested data is not available',
            response: response);
}

/// Invalid data exception {422}
class InvalidDataException extends ApiException {
  final Response response;

  InvalidDataException(this.response)
      : super(
          message:
              json.decode(response.body)['message'] ?? 'Something went wrong',
          response: response,
        );
}
