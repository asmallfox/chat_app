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
    Box chatBox = Hive.box('chat');

    List friendList = await chatBox.get('friendList', defaultValue: []);
    List chatList = await chatBox.get('chatList', defaultValue: []);
    List chatMessageList = await chatBox.get('chatMessage', defaultValue: []);

    List dataList = data is List ? data : [data];

    Map<String, List<Map<String, dynamic>>> messageGroup = {};

    for (int i = 0; i < dataList.length; i++) {
      final item = dataList[i];

      String fromId = item['from'].toString();

      if (messageGroup.containsKey(fromId)) {
        messageGroup[fromId]?.add(item);
      } else {
        messageGroup[fromId] = [item];
      }
    }

    messageGroup.forEach((key, value) {
      final currentUser = friendList
          .firstWhere((element) => element['friendId'].toString() == key);

      if (currentUser != null) {
        if (currentUser.containsKey('message')) {
          currentUser['message'].addAll(value);

        } else {
          currentUser['message'] = value;
        }
        currentUser['newMessageCount'] += value.length;

        final currentChat = chatList.firstWhere(
          (element) => element['friendId'].toString() == key,
          orElse: () => null,
        );
        if (currentChat == null) {
          chatList.insert(0, currentUser);
        } else {
          currentChat['message'] = currentUser['message'];
          currentChat['newMessageCount'] = currentUser['newMessageCount'];
        }
      }
    });

    chatMessageList.addAll(dataList);

    print(chatMessageList.length);
    print(chatList[0]['message'][0]);

    // await Hive.box('chat').put('friendList', friendList);
    // await Hive.box('chat').put('chatList', chatList);
    // await Hive.box('chat').put('chatMessage', chatMessageList);
  });
}
