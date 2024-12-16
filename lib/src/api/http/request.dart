import 'dart:async';
import 'dart:convert';

import 'package:chat_app/src/api/http/http_base_client.dart';
import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/helpers/message_helper.dart';
import 'package:http/http.dart' as http;

// 一、HTTP 状态码
// 二、HTTP 状态码分类
// 2XX 请求成功
// （1）200 - OK（请求成功）
// （2）204 - No Content（无内容）
// （3）206 - Partial Content（部分内容）
// 3XX 重定向
// （4）301 - Moved Permanently（永久移动）
// （5）302 - Found（临时移动）
// （6）303 - See Other（查看其他地址）
// （7）304 - Not Modified（未修改）
// （8）307 - Temporary Redirect（临时重定向）
// 4XX 客户端错误
// （9）400 - Bad Request（错误请求）
// （10）401 - Unauthorized（未经授权）
// （11）403 - Forbidden（拒绝请求）
// （12）404 - Not Found（无法找到）
// 5XX 服务器错误
// （13）500 - Internal Server Error（内部服务器错误）
// （14）503 - Service Unavailable（服务不可用）

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
      final response = await _httpBaseClient.get(
        Uri.parse(_getRequestUrl(url)),
        headers: headers,
      );

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      return responseJson;
    } catch (error) {
      _handleError(error, 'GET');
      rethrow;
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

      if (response.statusCode == 200) {
        return responseJson;
      }
      throw responseJson;
    } catch (error) {
      _handleError(error, 'POST');
      rethrow;
    }
  }

  void _handleError(Object error, [String? method]) {
    print(
        '${method == null ? '[Request Error]' : 'Error in $method request'}: ${error.runtimeType} => $error');

    if (error is TimeoutException) {
      MessageHelper.showToast(message: '请求超时！');
    } else if (error is http.ClientException) {
      MessageHelper.showToast(message: '服务器错误');
    }
  }
}

final httpRequest = HttpRequest(baseUrl: serverBaseUrl);
