import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/helpers/global_notification.dart';
import 'package:chat_app/src/helpers/message_helper.dart';
import 'package:chat_app/src/helpers/recording_helper.dart';
import 'package:chat_app/src/providers/model/chat_provider_model.dart';
import 'package:chat_app/src/socket/socket_api.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/webRtc/web_rtc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  const TestPage({
    super.key,
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
              setState(() {});
            },
            child: Text('刷新'),
          ),
          FilledButton(
            onPressed: () {
              _call();
            },
            child: Text('audio'),
          ),
          Text('远端'),
          Container(
            width: 200,
            height: 100,
            child: WebRtc.remoteRenderer?.srcObject != null
                ? RTCVideoView(
                    WebRtc.remoteRenderer!,
                    // mirror: true,
                  )
                : Text('未开启'),
          ),
          Text('本地'),
          Container(
            width: 200,
            height: 100,
            child: WebRtc.localRenderer?.srcObject != null
                ? RTCVideoView(
                    WebRtc.localRenderer!,
                    // mirror: true,
                  )
                : Text('未开启'),
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

  void _call() async {
    final offer = await WebRtc.createOffer();
    SocketApi.callSocketApi(
      {
        'to': 2,
        'from': UserHive.userInfo['id'],
        'type': ChatMessageType.audio.value,
        'offer': {
          'sdp': offer.sdp,
          'type': offer.type,
        }
      },
      (data) {
        if (data['user'] != null) {
          context.read<ChatProviderModel>().setCallData(data['user']);
        } else {
          WebRtc.closeConnection();
          MessageHelper.showToast(message: data['message'] ?? '对方忙');
          GlobalNotification.cancelAll();
        }
      },
    );
  }

  void _callHandle(Map data, int status) async {
    Map socketParams = {
      'to': data['id'],
      'from': UserHive.userInfo['id'],
      'type': ChatMessageType.audio.value,
      'sessionId': data['sessionId'],
      'status': status,
    };

    if (status == SessionStatus.agree.value) {
      final answer = await WebRtc.createAnswer(data['offer']);
      final answerMap = {
        'answer': {
          'sdp': answer.sdp,
          'type': answer.type,
        }
      };
      socketParams.addAll(answerMap);
    }

    SocketApi.callHandleSocketApi(socketParams, (res) {
      context.read<ChatProviderModel>().setIsCalling(!res['isError']);
    });
  }

  void _callEnd() async {
    await WebRtc.closeConnection();
    final data = context.read<ChatProviderModel>().callData!;
    SocketApi.callHandleSocketApi({
      'to': data['id'],
      'from': UserHive.userInfo['id'],
      'type': ChatMessageType.audio.value,
      'sessionId': data['sessionId'],
      'status': SessionStatus.reject.value,
    }, (res) {
      context.read<ChatProviderModel>().setCallData(null);
      context.read<ChatProviderModel>().setIsCalling(false);
    });
  }
}
