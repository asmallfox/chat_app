import 'dart:convert';

import 'package:chat_app/src/api/http/request.dart';
import 'package:chat_app/src/constants/const_data.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> registerApi(Map data) {
  // return http.post(
  //   Uri.parse('$serverBaseUrl/api/register'),
  //   headers: {
  //     'Content-Type': 'application/json',
  //   },
  //   body: jsonEncode(data),
  // );

  // return HttpRequest.post('/api/register', data: data);

  return httpRequest.post('/api/register', body: data);
}
