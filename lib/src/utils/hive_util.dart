import 'package:hive_flutter/adapters.dart';

class AppHive {
  static final appBox = Hive.box('app');

  static String? getToken() {
    return appBox.get('token');
  }

  static Map? getCurrentUser() {
    return appBox.get('userInfo');
  }
}

class UserHive extends AppHive {
  // 使用 Account 字段作为 Box 的名称
  static Box? _box;

  static Map? _userInfo;

  // 获取对应的 Box
  static Box get box {
    final currentUser = AppHive.getCurrentUser();
    if (currentUser != null && currentUser['account'] != null) {
      final account = currentUser['account'].toString();
      _box ??= Hive.box(account); // 延迟加载 Box
      return _box!;
    }
    throw Exception('No valid account found');
  }

  // 获取用户信息
  static Map getUserInfo() {
    final currentUserBox = box;
    return currentUserBox.toMap(); // 你可以根据 Box 存储的数据结构来调整这里的实现
  }

  static Map get userInfo {
    return getUserInfo();
  }
}
