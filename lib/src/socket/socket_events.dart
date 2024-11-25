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
    return data.first;
  } catch (e) {
    rethrow;
  }
}

void socketEvents(IO.Socket socket) {
  socket.on('friend_verify', (res) {
    try {
      final data = getHandleAck(res);

      final verifyData = UserHive.verifyData;

      List newFriendVerify = data is List ? data : [data];
      for (int i = 0; i < newFriendVerify.length; i++) {
        dynamic index = verifyData['data']
            .indexWhere((element) => element['id'] == newFriendVerify[i]['id']);
        if (index != -1) {
          verifyData['data'].removeAt(index);
        }
      }

      verifyData['newCount'] = verifyData['newCount'] + newFriendVerify.length;
      verifyData['data'].insertAll(0, newFriendVerify);
      UserHive.box.put('verifyData', verifyData);
    } catch (error) {
      print(error);
    }
  });
}
