import 'dart:async';
import 'dart:convert';

import 'package:chat_app/src/api/http/http_base_client.dart';
import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:http/http.dart' as http;

class HttpRequest {
  final HttpBaseClient _httpBaseClient = HttpBaseClient();
  String _baseUrl = serverBaseUrl;

  HttpRequest({String? baseUrl}) {
    _baseUrl = baseUrl ?? _baseUrl;
  }

  String get baseUrl => _baseUrl;
  HttpBaseClient get httpBaseClient => _httpBaseClient;

  String _getRequestUrl(String url) {
    return '$baseUrl$url';
  }

  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response =
          await _httpBaseClient.get(Uri.parse(url), headers: headers);

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      return responseJson;
    } catch (error) {
      print('Error in get request: $error');
      throw Exception(error);
    }
  }

  Future<Map<String, dynamic>> post(
    String url, {
    Object? body,
    Map<String, String>? headers,
    Encoding? encoding,
  }) async {
    try {
      final response = await _httpBaseClient.post(
        Uri.parse(_getRequestUrl(url)),
        body: body,
        headers: headers,
        encoding: encoding,
      );

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      if (responseJson['status'] != 200) {
        throw Exception(responseJson['message']);
      }
      return responseJson;
    } catch (error) {
      print('Error in post request: $error');
      throw Exception(error);
    }
  }
}

final httpRequest = HttpRequest(baseUrl: serverBaseUrl);
