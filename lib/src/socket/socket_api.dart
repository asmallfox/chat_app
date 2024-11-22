import 'package:chat_app/src/socket/socket_io_client.dart';

class SocketApi {
  /*
  * 添加好友
  */
  static void addFriendSocketApi(Map data) {
    SocketIOClient.emit('add_friend', data);
  }
}
