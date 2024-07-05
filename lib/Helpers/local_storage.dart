import 'package:hive/hive.dart';

class LocalStorage {
  Future<void> openHive() async {}

  static Map getUserInfo() {
    return Hive.box('settings').get('user');
  }

  static Box getUserBox() {
    final user = getUserInfo();
    return Hive.box('user_${user['id']}');
  }
}

// settings
// users

@HiveType(typeId: 0)
class UserInfo {
  final int id;
  final String username;
  final String nickname;
  final int? sex;
  final int? birth;
  final int last_online_time;
  final String? avatar;
  final int? provinces_code;
  final int? city_code;
  final int? districts_code;
  final int created_at;
  final int updated_at;
  final String? password;
  final String? vi;

  UserInfo({
    required this.id,
    required this.username,
    required this.nickname,
    required this.last_online_time,
    required this.created_at,
    required this.updated_at,
    this.password,
    this.vi,
    this.sex,
    this.birth,
    this.avatar,
    this.provinces_code,
    this.city_code,
    this.districts_code,
  });
}

class Settings {
  final String token;
  final UserInfo user;
  final String username;

  Settings({
    required this.token,
    required this.user,
    required this.username,
  });
}

class User {
  int id;
  List friends;
  List chatMessages;
  List groupMessages;
  List chatList;

  User({
    required this.id,
    required this.friends,
    required this.chatMessages,
    required this.groupMessages,
    required this.chatList,
  });
}




// class User {
//   final int id;
//   final String username;
//   final String nickname;
//   final int? sex;
//   final int? birth;
//   final int last_online_time;
//   final String? avatar;
//   final int? provinces_code;
//   final int? city_code;
//   final int? districts_code;
//   final int created_at;
//   final int updated_at;
//   final String? password;
//   final String? vi;

//   User({
//     required this.id,
//     required this.username,
//     required this.nickname,
//     required this.last_online_time,
//     required this.created_at,
//     required this.updated_at,
//     this.password,
//     this.vi,
//     this.sex,
//     this.birth,
//     this.avatar,
//     this.provinces_code,
//     this.city_code,
//     this.districts_code,
//   });
// }
