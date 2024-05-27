import 'package:chat_app/Apis/request.dart';

Future<Map<String, dynamic>> loginRequest(Map<String, dynamic> data) async {
  return HttpRequest.post('/api/login', data);
}