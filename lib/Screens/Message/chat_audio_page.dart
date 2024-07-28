import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/back_icon_button.dart';
import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/provider/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class ChatAudioPage extends StatefulWidget {
  const ChatAudioPage({
    super.key,
  });

  @override
  State<ChatAudioPage> createState() => _ChatAudioPageState();
}

class _ChatAudioPageState extends State<ChatAudioPage> {
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  MediaStream? localStream;
  bool isCall = false;

  @override
  void initState() {
    super.initState();
    localRenderer.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    localRenderer.dispose();
  }

  void call() async {
    print('童虎==================');
    MediaStream stream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });

    localStream = stream;
    localRenderer.srcObject = localStream;

    setState(() {
      isCall = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('测试'),
      ),
      body: Container(
        color: Colors.pink[100],
        width: double.infinity,
        child: Column(
          children: [
            Text('内容'),
            Visibility(
              visible: isCall,
              child: Container(
                width: 400,
                height: 400,
                color: Colors.red,
                child: RTCVideoView(
                  localRenderer,
                  mirror: true,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          call();
        },
        child: const Text('通话'),
      ),
    );
  }
}
