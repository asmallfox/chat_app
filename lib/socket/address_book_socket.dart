import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void addressBookSocket(IO.Socket socket) {
  socket.on('get_friend_list', (data) async {
    // Hive.box('chat').delete('friendList');
    // Hive.box('chat').delete('chatList');

    final friendList =
        await Hive.box('chat').get('friendList', defaultValue: []);

    final dataList = data is List ? data : [data];

    for (int i = 0; i < dataList.length; i++) {
      var item = dataList[i];
      final currentUser = friendList.firstWhere(
        (element) => element['friendId'] == item['friendId'],
        orElse: () => null,
      );

      if (currentUser != null) {
        dataList[i] = {...(currentUser as Map), ...(item as Map)};
      } else {
        item['messages'] = [];
        item['newMessageCount'] = 0;
      }
    }

    Hive.box('chat').put('friendList', dataList);
  });

  // socket.emit('get_friend_list');
}
