import 'dart:io';

import 'package:chat_app/src/constants/hive_boxes.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

class HiveHelper {
  static final HiveHelper _instance = HiveHelper._internal();

  HiveHelper._internal();

  factory HiveHelper() => _instance;

  static bool _isInitialized = false;

  static Future<HiveHelper> getInstance() async {
    if (!_isInitialized) {
      await _initialize();
    }

    return _instance;
  }

  static HiveHelper get instance => _instance;

  static Future<void> _initialize() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      await Hive.initFlutter('ChatApp/Database');
    } else if (Platform.isIOS) {
      await Hive.initFlutter('Database');
    } else {
      await Hive.initFlutter();
    }

    _isInitialized = true;

    for (final box in hiveBoxes) {
      _openHive(box['name'].toString(), limit: box['limit'] as bool);
    }
  }

  static Future<void> _openHive(String boxName, {bool limit = false}) async {
    final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
      // Logger.root.severe('无法打开 $boxName Box', error, stackTrace);
      final Directory dir = await getApplicationDocumentsDirectory();
      final String dirPath = dir.path;
      File dbFile = File('$dirPath/$boxName.hive');
      File lockFile = File('$dir/$boxName.lock');

      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        dbFile = File('$dirPath/chat/$boxName.hive');
        lockFile = File('$dirPath/chat/$boxName.lock');
      }

      await dbFile.delete();
      await lockFile.delete();
      await Hive.openBox(boxName);

      throw '无法打开 $boxName Box\n: $error';
    });

    // 如果box超过最大值，则清除存储
    if (limit && box.length > 500) {
      box.clear();
    }
  }
}

@HiveType(typeId: 1)
class User {
  @HiveField(1)
  String? token;

  @HiveField(2, defaultValue: 0.0)
  double? keyboard_max_height;
}