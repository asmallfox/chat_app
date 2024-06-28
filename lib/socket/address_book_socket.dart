import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void addressBookSocket(IO.Socket socket) {
  socket.on('get_friend_list', (data) async {
    Hive.box('chat').put('friendList', data);
  });

  // socket.emit('get_friend_list');
}
