
// part 'settings.g.dart'; // 生成的代码文件 flutter packages pub run build_runner build

// @HiveType(typeId: 1)
// class Settings {
//   @HiveField(0)
//   String? token;

//   Settings({
//     this.token,
//   });
// }

class Settings {
  final String? token;
  final String? id;

  Settings({
    this.token,
    this.id,
  });
}

// class SettingsAdapter extends TypeAdapter<Settings> {
//   @override
//   final typeId = 0;
// }


//  Hive.registerAdapter(UserAdapter()); // 注册适配器
