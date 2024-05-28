import 'package:chat_app/Apis/request.dart';

typedef DynamicMap = Map<String, dynamic>;

Future<DynamicMap> loginRequest(DynamicMap data) async {
  return HttpRequest.post('/api/login', data);
}
Future<DynamicMap> registerRequest(DynamicMap data) async {
  return HttpRequest.post('/api/register', data);
}
Future<DynamicMap> findUserRequest(DynamicMap data) async {
  return HttpRequest.get('/api/find-users', data);
}
Future<DynamicMap> addFriendRequest(DynamicMap data) async {
  return HttpRequest.post('/api/add-user/{id}', data);
}