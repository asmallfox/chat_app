import 'package:chat_app/src/socket/socket_io_client.dart';

class SocketApi {
  /*
  * 添加好友
  */
  static void addFriendSocketApi(Map data, [Function? callback]) {
    SocketIOClient.emitWithAck('add_friend', data, ack: callback);
  }

  // 好友验证
  static void friendVerifySocketApi(Map data, [Function? callback]) {
    SocketIOClient.emitWithAck('friend_verify', data,
        ack: callback, binary: true);
  }

  // 消息发送
  static void sendMsgSocketApi(Map data, [Function? callback]) {
    SocketIOClient.emitWithAck('chat_message', data, ack: callback);
  }
}
