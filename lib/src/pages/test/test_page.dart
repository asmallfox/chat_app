import 'dart:io';

import 'package:chat_app/src/helpers/recording_helper.dart';
import 'package:chat_app/src/utils/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';

class TestPage extends StatefulWidget {
  const TestPage({
    super.key,
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: Center(
        child: FilledButton(
          onPressed: () {
            getFileUrl();
          },
          child: Text('播放'),
        ),
      ),
    );
  }

  Future<void> getFileUrl() async {
    final byteData = await rootBundle.load('assets/mp3/chat_notice.mp3');
    final buffer = byteData.buffer.asUint8List();
    print('开始播放');
    RecordingHelper.audioPlayer.startPlayer(
      fromDataBuffer: buffer,
      codec: Codec.mp3,
      whenFinished: () {
        print('播放完毕');
      },
    );
  }
}
