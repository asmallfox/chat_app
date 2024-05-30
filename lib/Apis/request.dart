import 'dart:convert';

import 'package:chat_app/Helpers/local_storage.dart';
import 'package:http/http.dart' as http;

typedef DynamicMap<T> = Map<String, T>;

class HttpBaseClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  String? token = LocalStorage.getString('token');

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (token != null) {
      print('[Token] $token');
      request.headers['Authorization'] = 'Bearer $token';
    } else {}

    print('[请求头] ${request.headers}');
    return _inner.send(request);
  }
}

class HttpRequest {
  final String baseUrl;
  final HttpBaseClient _http = HttpBaseClient();

  HttpRequest({
    this.baseUrl = '10.0.2.2:3000', // localhost
  });

  Future<DynamicMap> get(
    String path, [
    DynamicMap? data,
    DynamicMap<String>? headers,
  ]) async {
    var options = _handleRequestOptions(
      path: path,
      params: data,
    );

    DynamicMap<String> headersConfig = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    if (headers != null) headersConfig.addAll(headers);

    final response = await _http.get(
      options['uri'],
      headers: headers,
    );

    return _handleResponse(response);
  }

  Future<DynamicMap> post(
    String path, [
    DynamicMap? data,
    DynamicMap<String>? headers,
    Encoding? encoding,
  ]) async {
    var options = _handleRequestOptions(
      path: path,
      params: data,
    );

    DynamicMap<String> headersConfig = {
    };

    if (headers != null) headersConfig.addAll(headers);

    final response = await _http.post(
      options['uri'],
      body: data,
      headers: headersConfig,
      encoding: encoding ?? Encoding.getByName('utf-8'),
    );

    return _handleResponse(response);
  }

  DynamicMap _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('[请求错误：${response.statusCode}] ${response.body}');
      return throw Exception(response);
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

    print('[请求数据处理结果] $result');
    return result;
  }
}

HttpRequest httpRequest = HttpRequest();