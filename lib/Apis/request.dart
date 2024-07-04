import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

typedef DynamicMap<T> = Map<String, T>;

class ResponseResult {
  final int status;
  final String message;
  final Map<String, dynamic> data;

  const ResponseResult({
    required this.status,
    required this.message,
    this.data = const {},
  });

  factory ResponseResult.fromJson(Map<String, dynamic> json) {
    return ResponseResult(
      status: json["status"],
      message: json["message"],
      data: json["data"] ?? {},
    );
  }
}

class HttpBaseClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    String? token = await Hive.box('settings').get('token');

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    } else {}

    return _inner.send(request);
  }
}

class HttpRequest {
  final String baseUrl;
  final HttpBaseClient _http = HttpBaseClient();

  HttpRequest({
    // this.baseUrl = '10.0.2.2:3000', // localhost
    this.baseUrl = 'http://192.168.31.22:3000', // localhost
  });

  Future<ResponseResult> get(
    String path, [
    DynamicMap? data,
    DynamicMap<String>? headers,
  ]) async {
    var options = _handleRequestOptions(
      path: path,
      queryParams: data,
    );

    DynamicMap<String> headersConfig = {
      // 'Content-Type': 'application/json; charset=utf-8',
    };

    if (headers != null) headersConfig.addAll(headers);

    final response = await _http.get(
      options['uri'],
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<ResponseResult> post(
    String path, [
    DynamicMap? data,
    DynamicMap<String>? headers,
    Encoding? encoding,
  ]) async {
    var options = _handleRequestOptions(
      path: path,
      params: data,
    );

    DynamicMap<String> headersConfig = {};

    if (headers != null) headersConfig.addAll(headers);

    final response = await _http.post(
      options['uri'],
      body: data,
      headers: headersConfig,
      encoding: encoding ?? Encoding.getByName('utf-8'),
    );

    return _handleResponse(response);
  }

  ResponseResult _handleResponse(http.Response response) {
    var json = jsonDecode(response.body);
    var res = ResponseResult.fromJson(json);
    if (response.statusCode == 200) {
      return res;
    } else {
      throw res.message;
    }
  }

  DynamicMap _handleRequestOptions({
    required String path,
    DynamicMap? params,
    DynamicMap? queryParams,
  }) {
    Map<String, dynamic> result = {};
    String url = path;
    RegExp reg = RegExp(r'{(.*?)}'); // 匹配 {xxx}

    final matchResult = reg.allMatches(url);

    DynamicMap? paramsFrom = Map.from(params ?? {});
    if (matchResult.isNotEmpty) {
      for (final match in matchResult) {
        String context = match.group(0) ?? '';
        String key = context.replaceAll(RegExp(r'[{}]'), '');
        url = url.replaceAll(context, paramsFrom[key].toString());
        paramsFrom.remove(key.toString());
      }
    }

    if (paramsFrom.isNotEmpty) {
      result.putIfAbsent('data', () => paramsFrom);
    }

    Uri uri = Uri.http(baseUrl, url, queryParams);
    result.putIfAbsent('uri', () => uri);

    return result;
  }
}

HttpRequest httpRequest = HttpRequest();
