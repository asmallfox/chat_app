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

class HiveSaveType {
  static const cover = 'cover';
  static const append = 'append';
}

class UserHive extends AppHive {
  // 使用 Account 字段作为 Box 的名称
  static Box? _box;

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

  static Map _getUserInfo() {
    final currentUserBox = box;
    return currentUserBox.toMap();
  }

  static Map get userInfo => _getUserInfo();

  static List get friends => box.get('friends', defaultValue: []);

  static void updateFriend(
    String findKey,
    dynamic findValue,
    String updateKey,
    dynamic value, [
    String? type = HiveSaveType.cover,
  ]) {
    final list = friends;
    final friend = list.firstWhere((element) => element[findKey] == findValue);

    if (friend != null) {
      if (type == HiveSaveType.cover) {
        friend[updateKey] = value;
      } else if (type == HiveSaveType.append) {
        if (friend[updateKey] == null) {
          friend[updateKey] = [value];
        } else {
          friend[updateKey].add(value);
        }
      }

      box.put('friends', list);
    } else {
      throw Exception('No valid find item found');
    }
  }

  static void saveFriends(List friends) {
    box.put('friends', friends);
  }
}
