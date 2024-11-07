import 'package:chat_app/src/utils/hive_util.dart';

class MessageUtil {
  static void add(String account, Map msg) {
    final List friends = UserHive.userInfo['friends'];

    final friend = friends.firstWhere((item) => item['account'] == account);

    if (friend != null) {
      if (friend['messages'] == null) {
        friend['messages'] = [msg];
      } else {
        friend['messages'].add(msg);
      }
    }

    UserHive.box.put('friends', friends);
  }

  static void update(Map msg) {}
  static void delete({
    required String account,
    String? id,
    int? sendTime,
  }) {
    final List friends = UserHive.userInfo['friends'] ?? [];

    final friend = friends.firstWhere((item) => item['account'] == account,
        orElse: () => null);

    if (friend != null) {
      final List list = friend['messages'];
      int index = list.indexWhere((element) =>
          (element['id'] != null && element['id'] == id) ||
          element['sendTime'] == sendTime);
      if (index != -1) {
        list.removeAt(index);
      } else {
        throw Exception('删除记录失败~');
      }
    } else {
      print('找不到好友 $account');
    }

    UserHive.box.put('friends', friends);
  }
}
