import 'package:hive_flutter/adapters.dart';

import './user.dart';

// @HiveType(typeId: 0)
class AppHiveModel extends HiveObject {
  @HiveField(0)
  String? token;

  @HiveField(1)
  UserHiveModel? userInfo;

  @HiveField(2)
  Map<String, dynamic>? setting;

  AppHiveModel({
    this.token,
    this.userInfo,
    this.setting,
  });
}

class AppHiveModelAdapter extends TypeAdapter<AppHiveModel> {
  @override
  final typeId = 1;

  @override
  AppHiveModel read(BinaryReader reader) {
    return AppHiveModel(
      token: reader.readString(),
      userInfo: reader.read(),
      setting: reader.readMap().cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, AppHiveModel obj) {
    writer
      ..write<String?>(obj.token)
      ..write<UserHiveModel?>(obj.userInfo)
      ..write<Map<String, dynamic>?>(obj.setting);
  }
}
