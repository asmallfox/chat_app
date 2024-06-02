import 'package:chat_app/Apis/request.dart';

Future<ResponseResult> loginRequest(DynamicMap data) async {
  return httpRequest.post('/api/login', data);
}

Future<ResponseResult> registerRequest(DynamicMap data) async {
  return httpRequest.post('/api/register', data);
}

Future<ResponseResult> findUserRequest(DynamicMap data) async {
  return httpRequest.get('/api/find-users', data);
}

Future<ResponseResult> addFriendRequest(DynamicMap data) async {
  return httpRequest.post('/api/add-user/{id}', data);
}
