import 'package:chat_app/Helpers/caceh_network_source.dart';
import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/helpers/message_helper.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/utils/message_util.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/*
 * 处理服务端回调函数
*/
dynamic handleAck(data) {
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
      final data = handleAck(res);
      UserHive.updateVerifyData(data);
      print('[friend_verify socket]');
    } catch (error) {
      print(error);
    }
  });

  socket.on('friends', (res) {
    try {
      UserHive.updateFriends(res);
      print('[friends socket]');
    } catch (error) {
      print(error);
    }
  });

  socket.on('chat_message', (res) async {
    final data = handleAck(res);

    final dataList = data is List ? data : [data];

    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i]['type'] == MessageType.image.value ||
          dataList[i]['type'] == MessageType.voice.value) {
        dataList[i]['content'] =
            await downloadAndSaveFile(dataList[i]['content']);
      }

      MessageUtil.add(dataList[i]['from'], dataList[i]);
    }
  });
}
