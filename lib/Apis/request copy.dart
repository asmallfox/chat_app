import 'dart:convert';

import 'package:http/http.dart' as http;

typedef DynamicMap<T> = Map<String, T>;

class HttpRequest {
  final String baseUrl;

  final client = http.Client();

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

    final response = await http.get(
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
      // 'Content-Type': 'application/json; charset=UTF-8',
    };

    if (headers != null) headersConfig.addAll(headers);

    final response = await http.post(
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

    print('[_handleRequestOptions] $result');
    return result;
  }
}

HttpRequest httpRequest = HttpRequest();
