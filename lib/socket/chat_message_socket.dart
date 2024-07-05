import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/Helpers/util.dart';
import 'package:chat_app/provider/model/chat_model.dart';
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatMessage {
  final int id;
  final int send_user_id;
  final int receive_user_id;
  final int type;
  final String message;
  final int to;
  final int from;
  final int? is_read;
  final int? created_at;
  final int? updated_at;

  ChatMessage({
    required this.id,
    required this.send_user_id,
    required this.receive_user_id,
    required this.type,
    required this.message,
    required this.to,
    required this.from,
    this.is_read,
    this.created_at,
    this.updated_at,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> item) {
    return ChatMessage(
      id: item['id'],
      send_user_id: item['send_user_id'],
      receive_user_id: item['receive_user_id'],
      type: item['type'],
      message: item['message'],
      to: item['to'],
      from: item['from'],
      is_read: item['is_read'],
      created_at: item['created_at'],
      updated_at: item['updated_at'],
    );
  }
}

void chatMessageSocket(IO.Socket socket) {
  socket.on('chat_message', (data) async {
    final dataList = data as List;
    final messages = dataList.first is List ? dataList.first : [dataList.first];
    final ack = dataList.last as Function;

    Map? currentChat = ChatModel.staticCurrentChat;

    Box userBox = LocalStorage.getUserBox();

    List friends = await userBox.get('friends', defaultValue: []);
    List chatList = await userBox.get('chatList', defaultValue: []);
    List chatMessageList = await userBox.get('chatMessage', defaultValue: []);

    Map<String, List<Map<String, dynamic>>> messageGroup = {};

    for (int i = 0; i < messages.length; i++) {
      final item = messages[i];

      String fromId = item['from'].toString();

      if (messageGroup.containsKey(fromId)) {
        messageGroup[fromId]?.add(item);
      } else {
        messageGroup[fromId] = [item];
      }
    }

    messageGroup.forEach((key, value) {
      Map? friend =
          listFind(friends, (item) => item['friendId'].toString() == key);

      if (friend != null) {
        if (friend.containsKey('messages')) {
          friend['messages'].addAll(value);
        } else {
          friend['messages'] = value;
        }

        Map? chatItem =
            listFind(chatList, (item) => item['friendId'].toString() == key);

        bool isCurrentChat = currentChat?['friendId'] == friend['friendId'];

        if (chatItem == null) {
          chatList.insert(0, {
            ...friend,
            'newMessageCount': isCurrentChat ? 0 : value.length,
          });
        } else {
          chatItem.addAll({
            ...friend,
            'newMessageCount':
                isCurrentChat ? 0 : chatItem['newMessageCount'] + value.length,
          });
        }
      }
    });

    chatMessageList.addAll(messages);

    await userBox.put('friendList', friends);
    await userBox.put('chatList', chatList);
    await userBox.put('chatMessage', chatMessageList);

    ack(null); // 通知服务端已收到消息
  });
}
