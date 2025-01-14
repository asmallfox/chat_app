import 'package:chat_app/src/api/http/request.dart';

/*
 * 用户注册
 * @param {string} name
 * @param {string} account
 * @param {string} password
 * @param {string} confirmPassword
 */
Future<Map<String, dynamic>> registerApi(Map data) {
  return httpRequest.post('/api/register', body: data);
}

/*
 * 用户登陆
 * @param {string} account
 * @param {string} password
 */
Future<Map<String, dynamic>> loginApi(Map data) {
  return httpRequest.post('/api/login', body: data);
}


/*
 * 获取用户信息
 * @param {string} id 用户id
 */
Future<Map<String, dynamic>> getUserInfoApi(Map data) {
  if (data['id'] == null) {
    throw ArgumentError('id is required.');
  }
  return httpRequest.get('/api/user-info/${data['id']}');
}

/*
 * 获取用户信息
 * @param {string} id 用户id
 */
Future<Map<String, dynamic>> findUsersApi(Map data) {
  if (data['account'] == null) {
    throw ArgumentError('account is required.');
  }
  return httpRequest.get('/api/find-users?account=${data['account']}');
}