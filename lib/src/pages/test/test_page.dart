import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/constants/global_key.dart';
import 'package:chat_app/src/helpers/global_notification.dart';
import 'package:chat_app/src/helpers/message_helper.dart';
import 'package:chat_app/src/helpers/recording_helper.dart';
import 'package:chat_app/src/providers/model/chat_provider_model.dart';
import 'package:chat_app/src/socket/socket_api.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  const TestPage({
    super.key,
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool _isCalling = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.read<ChatProviderModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: Column(
        children: [
          Visibility(
            visible: context.watch<ChatProviderModel>().callData != null,
            child: Row(
              children: [
                Text(chatProvider.callData?['name'] ?? ''),
                FilledButton(
                    onPressed: () {
                      _callHandle(chatProvider.callData!, 1);
                    },
                    child: Text('accept')),
                FilledButton(
                    onPressed: () {
                      _callHandle(chatProvider.callData!, 2);
                      chatProvider.setCallData(null);
                    },
                    child: Text('reject'))
              ],
            ),
          ),
          FilledButton(
            onPressed: () {
              RecordingHelper.play('assets/mp3/chat_notice.mp3', assets: true);
            },
            child: Text('play'),
          ),
          FilledButton(
            onPressed: () {
              _call();
            },
            child: Text('audio'),
          ),
          Visibility(
            visible: context.watch<ChatProviderModel>().isCalling,
            child: Row(
              children: [
                FilledButton(
                  onPressed: () {
                    _callEnd();
                  },
                  child: Text('end'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _call() {
    SocketApi.callSocketApi(
      {
        'to': 2,
        'from': UserHive.userInfo['id'],
        'type': MessageType.audio.value,
      },
      (data) {
        if (data['user'] != null) {
          context.read<ChatProviderModel>().setCallData(data['user']);
        } else {
          MessageHelper.showToast(message: data['message'] ?? '对方忙');
          GlobalNotification.cancelAll();
        }
      },
    );
  }

  void _callHandle(Map data, int status) {
    SocketApi.callHandleSocketApi({
      'to': data['id'],
      'from': UserHive.userInfo['id'],
      'type': MessageType.audio.value,
      'sessionId': data['sessionId'],
      'status': status,
    }, (res) {
      context.read<ChatProviderModel>().setIsCalling(!res['isError']);
    });
  }

  void _callEnd() {
    final data = context.read<ChatProviderModel>().callData!;
    SocketApi.callHandleSocketApi({
      'to': data['id'],
      'from': UserHive.userInfo['id'],
      'type': MessageType.audio.value,
      'sessionId': data['sessionId'],
      'status': SessionStatus.reject.value,
    }, (res) {
      context.read<ChatProviderModel>().setCallData(null);
      context.read<ChatProviderModel>().setIsCalling(false);
    });
  }
}
