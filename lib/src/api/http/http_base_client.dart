import 'package:chat_app/src/utils/hive_util.dart';
import 'package:http/http.dart' as http;

class HttpBaseClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    String? token = AppHive.getToken();

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    return _inner.send(request).timeout(const Duration(seconds: 3));
  }
}
