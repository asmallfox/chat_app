import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static Future<void> init() async {
    final appDOcumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDOcumentDir.path);

    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(SettingsAdapter());
  }
}

class BaseBox<T> {
  final String boxName;
  BaseBox(this.boxName);

  Future<Box<T>> _openBox() async {
    return await Hive.openBox<T>(boxName);
  }

  Future<void> put(String key, T value) async {
    final box = await _openBox();
    await box.put(key, value);
  }

  Future<T?> get(String key) async {
    final box = await _openBox();
    return box.get(key);
  }

  Future<void> delete(String key) async {
    final box = await _openBox();
    await box.delete(key);
  }

  Future<void> clear() async {
    final box = await _openBox();
    await box.clear();
  }

  Future<void> close() async {
    final box = await _openBox();
    await box.close();
  }
}

// ========================

// class User {
//   final String name;
//   final int age;

//   User(this.name, this.age);
// }

// class UserBox extends BaseBox<User> {
//   UserBox() : super('userBox');
// }

// class Settings {
//   final bool darkMode;

//   Settings(this.darkMode);
// }

// class SettingsBox extends BaseBox<Settings> {
//   SettingsBox() : super('settingsBox');
// }

class User {
  final String name;
  final int age;

  User(this.name, this.age);
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    return User(reader.readString(), reader.readInt());
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeString(obj.name);
    writer.writeInt(obj.age);
  }
}

class Settings {
  final bool darkMode;

  Settings(this.darkMode);
}

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 1;

  @override
  Settings read(BinaryReader reader) {
    return Settings(reader.readBool());
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer.writeBool(obj.darkMode);
  }
}
