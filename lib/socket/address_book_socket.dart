import 'package:chat_app/Helpers/util.dart';
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void addressBookSocket(IO.Socket socket) {
  socket.on('get_friend_list', (data) async {
    // Hive.box('chat').delete('friendList');
    // Hive.box('chat').delete('chatList');

    Map? user = await Hive.box('settings').get('user');

    if (user == null) return;

    final dataList = data is List ? data : [data];
    Box userBox = Hive.box('user_${user['id']}');
    List friends = await userBox.get('friends', defaultValue: []);

    for (int i = 0; i < dataList.length; i++) {
      Map item = dataList[i];
      Map? friend = listFind(
        friends,
        (element) => element['friendId'] == item['friendId'],
      );

      item['isDelete'] = false;

      if (friend == null) {
        item['messages'] = [];
        item['newMessageCount'] = 0;
        friends.add(item);
      } else {
        friend.addAll(item);
      }
    }

    // 处理被非好友关系的好友（已删除）
    for (int i = 0; i < friends.length; i++) {
      Map item = friends[i];
      Map? friend = listFind(
        dataList,
        (element) => element['friendId'] == item['friendId'],
      );

      if (friend == null) {
        item['isDelete'] = true;
      }
    }

    await userBox.put('friends', friends);
  });
}
