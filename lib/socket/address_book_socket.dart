import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void addressBookSocket(IO.Socket socket) {
  socket.on('get_friend_list', (data) async {
    final friendList =
        await Hive.box('chat').get('friendList', defaultValue: []);

    final dataList = data is List ? data : [data];

    for (int i = 0; i < dataList.length; i++) {
      var item = dataList[i];
      final currentUser = friendList
          .firstWhere((element) => element['friendId'] == item['friendId']);

      if (currentUser != null) {
        dataList[i] = {...(currentUser as Map), ...(item as Map)};
      } else {
        item['newMessageCount'] = 0;
        item['messages'] = [];
      }
    }

    Hive.box('chat').put('friendList', dataList);
  });

  // socket.emit('get_friend_list');
}
