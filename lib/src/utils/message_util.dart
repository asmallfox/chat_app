import 'dart:convert';
import 'dart:io';

import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/utils/share.dart';
import 'package:path_provider/path_provider.dart';

class MessageUtil {
  static void add(String account, Map msg) {
    final List friends = UserHive.userInfo['friends'];

    final friend = friends.firstWhere((item) => item['account'] == account);

    msg.remove('file');

    if (friend != null) {
      if (friend['messages'] == null) {
        friend['messages'] = [msg];
      } else {
        friend['messages'].add(msg);
      }
    }

    UserHive.box.put('friends', friends);
  }

  static void update(Map msg) {}
  static void delete({
    required String account,
    String? id,
    int? sendTime,
  }) {
    final List friends = UserHive.userInfo['friends'] ?? [];

    final friend = friends.firstWhere((item) => item['account'] == account,
        orElse: () => null);

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
    } else {
      print('找不到好友 $account');
    }

    UserHive.box.put('friends', friends);
  }

  static Future<void> sendMessage({
    required int type,
    required String content,
    required String from,
    required String to,
  }) async {
    Map msgData = {
      'type': type,
      'content': content,
      'from': from,
      'to': to,
      'sendTime': DateTime.now().millisecondsSinceEpoch
    };

    if (type == MessageType.text.value) {
    } else if (type == MessageType.image.value) {
      File imageFile = File(content);
      List<int> imageBytes = imageFile.readAsBytesSync();

      List<String> pList = content.split('/');
      String extension = pList.last.split('.')[1];
      File file = await pathTransformFile(content, extension);
      msgData['content'] = file.path;
      msgData.putIfAbsent('file', () => base64Encode(imageBytes));
    } else if (type == MessageType.voice.value) {
      File file = await pathTransformFile(content, 'acc');
       msgData['content'] = file.path;
      msgData.putIfAbsent('file', () => file.readAsBytesSync());
    } else if (type == MessageType.video.value) {
    } else if (type == MessageType.file.value) {}

    // save
    MessageUtil.add(to, msgData);

    // send
  }
}
