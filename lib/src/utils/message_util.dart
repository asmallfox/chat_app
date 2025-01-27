import 'dart:convert';
import 'dart:io';

import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/socket/socket_api.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/utils/share.dart';

class MessageUtil {
  static void add(String friendAccount, Map msg) {
    final isSelf = friendAccount == msg['to'];

    final List friends = UserHive.userInfo['friends'];
    final friend = friends.firstWhere(
        (item) => item['account'] == friendAccount,
        orElse: () => null);

    msg.remove('file');

    if (friend != null) {
      if (friend['messages'] == null) {
        friend['messages'] = [msg];
      } else {
        friend['messages'].add(msg);
      }
    }

    UserHive.box.put('friends', friends);

    final List chatList = UserHive.chatList;

    int chatIndex =
        chatList.indexWhere((item) => item['account'] == friendAccount);

    if (chatIndex == -1) {
      chatList.insert(0, {
        'account': friendAccount,
        'id': friend['id'],
        'newCount': isSelf ? 0 : 1,
      });
    } else {
      final chatItem = chatList[chatIndex];
      chatItem['newCount'] += isSelf ? 0 : 1;
      chatList.removeAt(chatIndex);
      chatList.insert(0, chatItem);
    }
    UserHive.box.put('chatList', chatList);
  }

  static void update(Map msg, Map oldMsg) {
    final List friends = UserHive.userInfo['friends'];
    final friend =
        friends.firstWhere((item) => item['account'] == oldMsg['to']);
    if (friend != null) {
      final messages = friend['messages'];

      int index = messages.indexWhere((item) =>
          item['sendTime'] == oldMsg['sendTime'] &&
          item['status'] == oldMsg['status']);

      if (index != -1) {
        messages[index] = msg;
        if (msg['type'] == ChatMessageType.audio.value ||
            msg['type'] == ChatMessageType.image.value) {
          messages[index]['content'] = oldMsg['content'];
        }
        UserHive.box.put('friends', friends);
      }
    }
  }

  static void delete({
    required String account,
    int? id,
    int? sendTime,
  }) {
    try {
      final friends = UserHive.friends;

      final Map? friend = friends
          .firstWhere((item) => item['account'] == account, orElse: () => null);

      if (friend != null) {
        final List list = friend['messages'];
        int index = list.indexWhere((element) =>
            (element['id'] != null && element['id'] == id) ||
            element['sendTime'] == sendTime);

        if (index != -1) {
          list.removeAt(index);
        } else {
          throw Exception('删除记录失败~');
        }
        UserHive.box.put('friends', friends);
      } else {
        print('找不到好友 $account');
      }
    } catch (error) {
      print(error);
    }
  }

  static Future<void> sendMessage({
    required int type,
    required String content,
    required String from,
    required String to,
    int? duration,
  }) async {
    Map msgData = {
      'type': type,
      'content': content,
      'from': from,
      'to': to,
      'sendTime': DateTime.now().millisecondsSinceEpoch,
      'status': MsgStatus.sending.value,
      'duration': duration
    };
    print(msgData);
    if (type == ChatMessageType.text.value) {
    } else if (type == ChatMessageType.image.value) {
      File imageFile = File(content);
      List<int> imageBytes = imageFile.readAsBytesSync();

      List<String> pList = content.split('/');
      String extension = pList.last.split('.')[1];
      File file = await pathTransformFile(content, extension);
      msgData['content'] = file.path;
      msgData.putIfAbsent('file', () => base64Encode(imageBytes));
    } else if (type == ChatMessageType.audio.value) {
      File file = await pathTransformFile(content, 'acc');
      msgData['content'] = file.path;
      msgData.putIfAbsent('file', () => file.readAsBytesSync());
    } else if (type == ChatMessageType.video.value) {
    } else if (type == ChatMessageType.file.value) {}

    // send
    SocketApi.sendMsgSocketApi(msgData, (res) {
      res['status'] = MsgStatus.sent.value;
      MessageUtil.update(res, msgData);
    });

    // save
    MessageUtil.add(to, msgData);
  }

  static List getMessages(String account) {
    final List friends = UserHive.userInfo['friends'];
    final friend = friends.firstWhere((item) => item['account'] == account);
    if (friend != null) {
      return friend['messages'] ?? [];
    }
    return [];
  }
}
