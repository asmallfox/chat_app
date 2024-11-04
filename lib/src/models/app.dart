import 'package:hive_flutter/adapters.dart';

import './user.dart';

@HiveType(typeId: 0)
class AppHiveModel extends HiveObject {
  @HiveField(0)
  String token;

  @HiveField(1)
  UserHiveModel userInfo;

  @HiveField(2)
  Map<String, dynamic>? setting;

  AppHiveModel({
    required this.token,
    required this.userInfo,
  });
}
