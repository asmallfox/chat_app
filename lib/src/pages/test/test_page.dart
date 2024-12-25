<<<<<<< HEAD
import 'package:chat_app/src/constants/global_key.dart';
import 'package:chat_app/src/helpers/recording_helper.dart';
import 'package:chat_app/src/providers/model/chat_provider_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
=======
import 'dart:io';

import 'package:chat_app/src/helpers/recording_helper.dart';
import 'package:chat_app/src/utils/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
>>>>>>> 50da8ced605261a9cac95b68bfe5761205ca70af

class TestPage extends StatefulWidget {
  const TestPage({
    super.key,
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  double decibels = 10;
  List<double> list = List.generate(20, (index) => 4);

  bool _isRecord = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
<<<<<<< HEAD
      body: Column(
        children: [
          FilledButton(
            onPressed: () async {
              try {
                await RecordingHelper.audioRecorder.openRecorder();
                RecordingHelper.audioRecorder
                    .setSubscriptionDuration(const Duration(milliseconds: 100));
                RecordingHelper.audioRecorder.onProgress?.listen((e) {
                  double decibels = (e.decibels ?? 4) < 4 ? 4 : e.decibels!;
                  setState(() {
                    list.removeAt(0);
                    list.add(decibels);
                  });
                });
                await RecordingHelper.audioRecorder.startRecorder(
                  toFile: 'test_audio.aac',
                  enableVoiceProcessing: true,
                );
              } catch (e) {
                print(e);
              }
            },
            child: Text('record'),
          ),
          FilledButton(
            onPressed: () async {
              String? filePath =
                  await RecordingHelper.audioRecorder.stopRecorder();
              list.fillRange(0, list.length, 4);
              print(filePath);
            },
            child: Text('stop'),
          ),
          CustomPaint(
            size: const Size(200, 100),
            painter: AudioCablePainter(
              list: list,
              decibels: decibels,
              offset: 10,
            ),
          ),
          GestureDetector(
            onPanDown: (details) => _handleStartRecording(context, details),
            onLongPressMoveUpdate: (details) =>
                _handleStartRecording(context, details),
            onVerticalDragUpdate: (details) =>
                _handleStartRecording(context, details),
            onHorizontalDragUpdate: (details) =>
                _handleStartRecording(context, details),
            onLongPressUp: () => _handleStopRecording(context),
            onTapUp: (_) => _handleStopRecording(context),
            onVerticalDragEnd: (_) => _handleStopRecording(context),
            onHorizontalDragEnd: (_) => _handleStopRecording(context),
            child: Container(
              color: Colors.pink,
              child: const Text('按住 说话'),
            ),
          ),
          Visibility(
            visible: _isRecord,
            child: FilledButton(
              onPressed: () {
                _isRecord = false;
              },
              child: Text('取消'),
            ),
          ),
        ],
=======
      body: Center(
        child: FilledButton(
          onPressed: () {
            getFileUrl();
          },
          child: Text('播放'),
        ),
>>>>>>> 50da8ced605261a9cac95b68bfe5761205ca70af
      ),
    );
  }

<<<<<<< HEAD
  void _handleStartRecording(BuildContext context, details) {
    if (!_isRecord) {
      showRecordingPanel(
        context: context,
        list: list,
        decibels: decibels,
      );
    }

    final recordSendBtn =
        _widgetCoincide(recordingSendBtnKey, details.globalPosition, 1);

    final recordCancelBtn =
        _widgetCoincide(recordingCancelBtnKey, details.globalPosition, 2);
    print(recordSendBtn);
    setState(() {
      _isRecord = true;
    });

    context.read<ChatProviderModel>().setIsRecord(true);
    context.read<ChatProviderModel>().setRecordCancelBtn(recordCancelBtn);
    context.read<ChatProviderModel>().setRecordSendBtn(recordSendBtn);
  }

  void _handleStopRecording(BuildContext context) {
    setState(() {
      _isRecord = false;
    });
    context.read<ChatProviderModel>().setIsRecord(false);
    context.read<ChatProviderModel>().setRecordCancelBtn(false);
    context.read<ChatProviderModel>().setIsRecord(false);
    Navigator.pop(context);
  }

  bool _widgetCoincide(GlobalKey widgetKey, Offset position, int type) {
    if (widgetKey.currentContext == null) return type == 1;

    RenderBox renderBox =
        widgetKey.currentContext?.findRenderObject() as RenderBox;

    Offset offset = renderBox.localToGlobal(Offset.zero);
    double boxX = offset.dx;
    double boxY = offset.dy;
    double x = position.dx;
    double y = position.dy;
    double sizeW = renderBox.size.width;
    double sizeH = renderBox.size.height;

    bool coincide =
        (x > boxX && x < boxX + sizeW) && (y > boxY && y < boxY + sizeH);
    return coincide;
  }
}

void showRecordingPanel({
  required BuildContext context,
  required List<double> list,
  required double decibels,
}) {
  showDialog(
    barrierColor: Colors.black.withOpacity(0.68),
    context: context,
    builder: (_) {
      return Consumer<ChatProviderModel>(
        builder: (context, chatProvider, child) {
          double width = MediaQuery.of(context).size.width;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                key: recordingCancelBtnKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Align(
                        child: CustomPaint(
                          size: const Size(200, 100),
                          painter: AudioCablePainter(
                            list: list,
                            decibels: decibels,
                            offset: 10,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.only(bottom: 40),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: chatProvider.recordCancelBtn
                                ? Colors.black26
                                : Colors.black38,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: chatProvider.recordCancelBtn
                                ? Colors.grey[100]
                                : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                key: recordingSendBtnKey,
                width: width,
                height: 140,
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        '松开 发送',
                        style: TextStyle(
                          color: Colors.white.withOpacity(
                              chatProvider.recordSendBtn ? 0.72 : 0),
                          fontSize: 16,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: -(width * 0.5 / 2),
                      child: ClipOval(
                        child: Container(
                          width: width * 1.5,
                          height: 400,
                          color: chatProvider.recordSendBtn
                              ? Colors.black26
                              : Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

class AudioCablePainter extends CustomPainter {
  final List<double> list;
  final double offset;
  final double? decibels;
  AudioCablePainter({
    required this.list,
    required this.offset,
    this.decibels = 10,
  });

  // 背景和绘制画笔
  final Paint backgroundPaint = Paint()..color = Colors.blue;
  final Paint rectPaint = Paint()..color = Colors.white;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    canvas.drawRect(rect, backgroundPaint);

    double left = 10;
    double horizontalSpacing = 4;

    for (int i = 0; i < list.length; i++) {
      left += horizontalSpacing * 2;

      RRect rRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(left, 50),
          width: 4,
          height: list[i],
        ),
        const Radius.circular(10),
      );
      canvas.drawRRect(rRect, rectPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
=======
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
>>>>>>> 50da8ced605261a9cac95b68bfe5761205ca70af
}
