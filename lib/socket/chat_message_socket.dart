import 'package:chat_app/Helpers/caceh_network_source.dart';
import 'package:chat_app/Helpers/find_data.dart';
import 'package:chat_app/Helpers/global_notification.dart';
import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/provider/model/chat_model.dart';
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


void chatMessageSocket(IO.Socket socket) {
  // 消息通知
  socket.on('chat_message', (data) async {
    print('[新消息]：$data');
    final dataList = data as List;
    final messages = dataList.first is List ? dataList.first : [dataList.first];
    final ack = dataList.last as Function;

    Map? currentChat = ChatModelProvider().chat;

    Box userBox = LocalStorage.getUserBox();

    List friends = await userBox.get('friends', defaultValue: []);
    List chatList = await userBox.get('chatList', defaultValue: []);
    List chatMessageList = await userBox.get('chatMessage', defaultValue: []);

    Map<String, List<Map<String, dynamic>>> messageGroup = {};
    // 信息按钮用户分组
    for (int i = 0; i < messages.length; i++) {
      final item = messages[i];
      String fromId = item['from'].toString();

      // 需要缓存的文件路径
      if (item['type'] == 3) {
        String? msgUrl = await downloadAndSaveFile(item['message']);
        if (msgUrl != null) {
          item['message'] = msgUrl;
        }
      }

      if (messageGroup.containsKey(fromId)) {
        messageGroup[fromId]?.add(item);
      } else {
        messageGroup[fromId] = [item];
      }
    }

    messageGroup.forEach((key, value) {
      Map? friend = findFriend(int.parse(key));

      if (friend != null) {
        if (friend.containsKey('messages')) {
          friend['messages'].addAll(value);
        } else {
          friend['messages'] = value;
        }

        Map? chatItem = findChatItem(int.parse(key));

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

        // 推送语音通话请求
        if (!isCurrentChat) {
          GlobalNotification().send({
            'title': friend['nickname'],
            'body': value.last['message'],
            'payload': '1,${friend['friendId']}', // type,friendId
          });
        }
      }
    });

    chatMessageList.addAll(messages);

    await userBox.put('friendList', friends);
    await userBox.put('chatList', chatList);
    await userBox.put('chatMessage', chatMessageList);

    ack(null);
  });

  // 语音通话
  socket.on('offer', (data) {
    print('[语音通话 offer]');

    ChatModelProvider().setCommunicate(data);

    // 推送语音通话请求
    GlobalNotification().send({'title': '通话', 'body': '语音通话'});
  });

  socket.on('answer', (data) {
    print('[语音通话 answer]');

    ChatModelProvider().setAnswer(data);
  });

  socket.on('hang-up', (res) {
    print('[对方拒绝通话]');
    ChatModelProvider().stopPeerConnection();
  });
}
