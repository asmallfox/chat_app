import 'dart:convert';
import 'package:http/http.dart' as http;

typedef DynamicMap = Map<String, dynamic>;

class Result {
  final Uri uri;
  final DynamicMap data;

  Result({required this.uri, required this.data});
}

class HttpRequest {
  static const String baseUrl = '10.0.2.2:3000'; // localhost

  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic>? data, [
    Map<String, String>? headers,
    Encoding? encoding,
  ]) async {
    try {
      final options = handleRequestParams(path: path, params: data);
      print('请求地址：${options['uri']}');
      final response = await http.post(
        options['uri'],
        headers: headers ??
            <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
        body: jsonEncode(options['data']),
        encoding: encoding ?? Encoding.getByName('utf8'),
      );
      print(response.body);

      final result = getJsonData(response.body);
      if (response.statusCode == 200) {
        return result;
      } else {
        throw _handlerErrorResponse(response);
      }
    } catch (err) {
      print('[post 错误] $err');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> get(
    String path,
    Map<String, dynamic>? data, [
    Map<String, String>? headers,
  ]) async {
    try {
      final options = handleRequestParams(path: path, queryParams: data);

      final response = await http.get(
        options['uri'],
        headers: headers,
      );
      final result = getJsonData(response.body);
      if (response.statusCode == 200) {
        return result;
      } else {
        throw _handlerErrorResponse(response);
      }
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  static getJsonData(String body) {
    return jsonDecode(body);
  }

  static Map<String, dynamic> _handlerErrorResponse(http.Response res) {
    final errorData = getJsonData(res.body);
    return {
      'code': res.statusCode,
      'data': errorData,
      'message': errorData['message'],
    };
  }

  static Map<String, dynamic> handleRequestParams({
    required String path,
    DynamicMap? params,
    DynamicMap? queryParams,
  }) {
    Map<String, dynamic> result = {};
    String url = path;
    RegExp reg = RegExp(r'{(.*?)}'); // 匹配 {xxx}

    final matchResult = reg.allMatches(url);

    DynamicMap? paramsFrom = Map.from(params ?? {});

    try {
      if (matchResult.isNotEmpty) {
        for (final match in matchResult) {
          String context = match.group(0) ?? '';
          String key = context.replaceAll(RegExp(r'[{}]'), '');
          url = url.replaceAll(context, paramsFrom[key].toString());
          paramsFrom.remove(key.toString());
        }
        Uri uri = Uri.http(baseUrl, url);
        result.putIfAbsent('uri', () => uri);
      }
    } catch (error) {
      print('[handleRequestParams 错误了] $error');
    }

    if (queryParams != null) {
      Uri uri = Uri.http(baseUrl, url, queryParams);
      result.putIfAbsent('uri', () => uri);
    }

    if (paramsFrom.isNotEmpty) {
      result.putIfAbsent('data', () => paramsFrom);
    }

    return result;
  }
}
