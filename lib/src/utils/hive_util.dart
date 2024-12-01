import 'package:chat_app/src/utils/share.dart';
import 'package:hive_flutter/adapters.dart';

class HiveSaveType {
  static const cover = 'cover';
  static const append = 'append';
}

class AppHive {
  static final _appBox = Hive.box('app');

  static Box get box => _appBox;

  static String? get token => _appBox.get('token');

  static String? getToken() {
    return _appBox.get('token');
  }

  static Map? get getCurrentUser {
    return _appBox.get('userInfo');
  }

  static Future<void> setUserInfo(Map data) async {
    await _appBox.put('userInfo', data);
  }
}

/*
 * UserHive
 *  - userInfo => Map
 *  - token => String 
 *  - friends => List<Map>
 *  - chatList => List<Map>
 *  - urlMap => Map<String, String>
*/
class UserHive extends AppHive {
  // 使用 Account 字段作为 Box 的名称
  static Box? _box;

  // 获取对应的 Box
  static Box get box {
    final currentUser = AppHive.getCurrentUser;
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
  static Map get urlMap => box.get('urlMap', defaultValue: {});

  static List get friends => box.get('friends', defaultValue: []);
  static List get chatList => box.get('chatList', defaultValue: []);

  /*
   * Map {
   *  newCount: number,
   *  data: List<Map<String, dynamic>> []
   * }
  */
  static Map<dynamic, dynamic> get verifyData =>
      box.get('verifyData', defaultValue: {'newCount': 0, 'data': []});

  static Future<void> setBoxData(Map data) async {
    await box.putAll({
      'friends': friends,
      'chatList': chatList,
      ...data,
    });
    await AppHive.setUserInfo(data);
  }

  static Future<List> updateFriends(List rows) async {
    final list = friends;
    for (int i = 0; i < rows.length; i++) {
      final row = rows[i];
      final index =
          list.indexWhere((item) => item['friendId'] == row['friendId']);

      await UserHive.getNetworkUrl(row['avatar']);

      if (index != -1) {
        list[index].addAll(row);
      } else {
        list.add(row);
      }
    }

    box.put('friends', list);
    return list;
  }

  static void updateFriendItem(
    String findKey,
    dynamic findValue,
    String updateKey,
    dynamic value, [
    String? type = HiveSaveType.cover,
  ]) async {
    final list = friends;
    final friend = list.firstWhere((element) => element[findKey] == findValue);

    if (friend != null) {
      await UserHive.getNetworkUrl(friend['avatar']);

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

  static void updateVerifyData(res, [bool notice = true]) {
    final localData = UserHive.verifyData;
    List newFriendVerify = res is List ? res : [res];
    for (int i = 0; i < newFriendVerify.length; i++) {
      dynamic index = verifyData['data']
          .indexWhere((element) => element['id'] == newFriendVerify[i]['id']);
      if (index != -1) {
        verifyData['data'].removeAt(index);
      }
    }

    if (notice) {
      localData['newCount'] = verifyData['newCount'] + newFriendVerify.length;
    }
    localData['data'].insertAll(0, newFriendVerify);
    // verifyData['data'] = [];
    UserHive.box.put('verifyData', localData);
  }

  static Future<String> getNetworkUrl(String path) async {
    final urlMap = box.get('urlMap', defaultValue: {});

    String? url = urlMap[path];
    if (url == null) {
      url = await downloadAndSaveFile(path);
      urlMap[path] = url;
    }

    UserHive.box.put('urlMap', urlMap);
    return url!;
  }
}
