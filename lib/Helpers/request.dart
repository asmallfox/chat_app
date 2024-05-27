import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class HttpRequest {
  static const String baseUrl = '192.168.31.15:3000';

  // static Future<Map<String, dynamic>> get() async {
  //   final response = await http.get()
  // }

  // static request(Map<String, dynamic> options) {
  //   String method = (options['method'] ?? 'get').toLowerCase();

  //   return http[options[method]]();
  // }

  static Future<http.Response> post(
    String path,
    Map<String, dynamic>? body, [
    Map<String, String>? headers,
    Encoding? encoding,
  ]) async {
    final response = await http.post(
      getUrl(path),
      body: body,
      headers: headers,
      encoding: encoding ?? Encoding.getByName('utf8'),
    );
    response.bodyBytes;
    return response;
  }

  static Uri getUrl(String path) {
    return Uri.http(baseUrl, path);
  }

  static Map<String, dynamic> getJsonData(Uint8List bodyBytes) {
    return jsonDecode(utf8.decoder)
  }
}
