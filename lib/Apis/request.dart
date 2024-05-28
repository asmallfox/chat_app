import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpRequest {
  static const String baseUrl = '10.0.2.2:3000'; // localhost

  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic>? data, [
    Map<String, String>? headers,
    Encoding? encoding,
  ]) async {
    try {
      final response = await http.post(
        getUrl(path, data),
        body: data,
        headers: headers,
        encoding: encoding ?? Encoding.getByName('utf8'),
      );
      response.body;
      final result = getJsonData(response.body);
      if (response.statusCode == 200) {
        return result;
      } else {
        throw _handlerErrorResponse(response);
      }
    } catch (err) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> get(
    String path,
    Map<String, dynamic>? data, [
    Map<String, String>? headers,
  ]) async {
    try {
      if (data != null) {}
      final response = await http.get(
        getUrl(path, data),
        headers: headers,
      );
      response.body;
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

  static Uri getUrl(String path, [Map<String, dynamic>? query]) {
    try {
      Uri uri = Uri.http(baseUrl, path);
      if (query != null) {
        String url = path;
        RegExp reg = RegExp(r'{(.*?)}');
        Map<String, dynamic> deepQuery = Map.from(query);
        for (final match in reg.allMatches(path)) {
          String content = match.group(0).toString();
          String key = content.substring(1, content.length - 1);
          url = url.replaceAll(content, deepQuery[key]?.toString() ?? '');
          deepQuery.remove(key);
        }
        print('==================');
        print(url);
        print(deepQuery.runtimeType.toString());
        
        uri = Uri.http(baseUrl, url, deepQuery);
      }
      print('当前请求地址：${uri.toString()}');
      return uri;
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
}
