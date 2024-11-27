import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/*
 * 处理服务端回调函数
*/
dynamic getHandleAck(data) {
  try {
    final ack = data is List ? data.last : data;
    if (ack is Function) {
      data.removeLast();
      ack(null);
    }
    return data is Map ? data : data.first;
  } catch (e) {
    rethrow;
  }
}

void socketEvents(IO.Socket socket) {
  socket.on('friend_verify', (res) {
    try {
      final data = getHandleAck(res);
      UserHive.updateVerifyData(data);
      print('[friend_verify socket]');
    } catch (error) {
      print(error);
    }
  });

  socket.on('friends', (res) {
    try {
      UserHive.updateFriends(res);
      print('friends => $res');
      print('[friends socket]');
    } catch (error) {
      print(error);
    }
  });
}
