import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class HttpRequest {
  static const String baseUrl = '10.0.2.2:3000'; // localhost

  static  Future<Map<String, dynamic>> post(
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
    return getJsonData(response.bodyBytes);
  }

  static Uri getUrl(String path) {
    return Uri.http(baseUrl, path);
  }

  static Future<Map<String, dynamic>> getJsonData(Uint8List bodyBytes) async {
    return jsonDecode(utf8.decode(bodyBytes));
  }
}
