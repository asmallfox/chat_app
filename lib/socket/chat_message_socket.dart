import 'package:chat_app/Helpers/util.dart';
import 'package:chat_app/provider/model/chat_model.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
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

    print('[chat_message] $messages');

    Box chatBox = Hive.box('chat');

    List friendList = await chatBox.get('friendList', defaultValue: []);
    List chatList = await chatBox.get('chatList', defaultValue: []);
    List chatMessageList = await chatBox.get('chatMessage', defaultValue: []);

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
      Map? currentFriend =
          listFind(friendList, (item) => item['friendId'].toString() == key);

      if (currentFriend != null) {
        if (currentFriend.containsKey('messages')) {
          currentFriend['messages'].addAll(value);
        } else {
          currentFriend['messages'] = value;
        }

        Map? chatItem =
            listFind(chatList, (item) => item['friendId'].toString() == key);

        if (chatItem == null) {
          chatList.insert(0, {
            ...currentFriend,
            'newMessageCount':
                currentChat?['friendId'] == currentFriend['friendId']
                    ? 0
                    : value.length,
          });
        } else {
          chatItem.addAll({
            ...currentFriend,
            'newMessageCount':
                currentChat?['friendId'] == currentFriend['friendId']
                    ? 0
                    : chatItem['newMessageCount'] + value.length,
          });
        }
        print(currentChat);
        print(currentChat?['friendId'] == currentFriend['friendId']);
        print('${currentChat?['friendId']}, ${currentFriend['friendId']}');
      }
    });

    ack(null);

    chatMessageList.addAll(messages);

    await Hive.box('chat').put('friendList', friendList);
    await Hive.box('chat').put('chatList', chatList);
    await Hive.box('chat').put('chatMessage', chatMessageList);
  });
}
