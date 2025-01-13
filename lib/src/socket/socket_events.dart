import 'dart:io';

import 'package:chat_app/Helpers/caceh_network_source.dart';
import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/constants/global_key.dart';
import 'package:chat_app/src/helpers/global_notification.dart';
import 'package:chat_app/src/helpers/message_helper.dart';
import 'package:chat_app/src/helpers/recording_helper.dart';
import 'package:chat_app/src/providers/model/chat_provider_model.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/utils/message_util.dart';
import 'package:chat_app/src/webRtc/web_rtc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

Future<String> _copyAssetToTempDir() async {
  // 获取临时目录路径
  final directory = await getTemporaryDirectory();
  final audioFilePath = '${directory.path}/chat_notice.mp3';

  // 复制音频文件到临时目录
  final byteData = await rootBundle.load('assets/mp3/chat_notice.mp3');
  final buffer = byteData.buffer.asUint8List();
  final file = File(audioFilePath);
  await file.writeAsBytes(buffer);

  return audioFilePath;
}

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
    RecordingHelper.play('assets/mp3/chat_notice.mp3', assets: true);

    final data = handleAck(res);

    final dataList = data is List ? data : [data];

    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i]['type'] == ChatMessageType.image.value ||
          dataList[i]['type'] == ChatMessageType.audio.value) {
        dataList[i]['content'] =
            await downloadAndSaveFile(dataList[i]['content']);
      }

      MessageUtil.add(dataList[i]['from'], dataList[i]);
    }
  });

  socket.on('call', (res) {
    try {
      final data = handleAck(res);
      String title = '消息';
      int type = data['type'];
      if (type == ChatMessageType.audio.value) {
        title = '语音通话';
      } else if (type == ChatMessageType.video.value) {
        title = '视频通话';
      }
      GlobalNotification.show(data,
          title: title, body: data['user']['name'], timeoutAfter: 1000 * 60);
      appNavigatorKey.currentContext!
          .read<ChatProviderModel>()
          .setCallData(data['user']);
    } catch (error) {
      print(error);
    }
  });

  socket.on('call-handle', (res) async {
    try {
      final data = handleAck(res);
      print('call-handle: $data');
      bool isAgree = data['status'] == SessionStatus.agree.value;
      if (isAgree) {
        await WebRtc.setAnswer(data['answer']);
      } else {
        appNavigatorKey.currentContext!
            .read<ChatProviderModel>()
            .setCallData(null);
        await WebRtc.closeConnection();
      }
      appNavigatorKey.currentContext!
          .read<ChatProviderModel>()
          .setIsCalling(isAgree);
    } catch (error) {
      print(error);
    }
  });
}
