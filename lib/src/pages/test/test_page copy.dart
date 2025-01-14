import 'package:chat_app/src/helpers/recording_helper.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({
    super.key,
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  void initState() {
    super.initState();
  }

  double decibels = 10;
  List<double> list = List.generate(20, (index) => 4);

  bool _isRecord = false;
  bool _recordSendBtn = false;
  bool _recordCancelBtn = false;

  GlobalKey _recordingCancelBtnKey = GlobalKey();
  GlobalKey _recordingSendBtnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: Column(
        children: [
          FilledButton(
            onPressed: () async {
              try {
                await RecordingHelper.audioRecorder.openRecorder();
                RecordingHelper.audioRecorder
                    .setSubscriptionDuration(const Duration(milliseconds: 100));
                RecordingHelper.audioRecorder.onProgress?.listen((e) {
                  print(e.decibels);
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
              list.fillRange(0, list.length - 1, 4);
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
            onPanDown: _handleStartRecording,
            onLongPressMoveUpdate: _handleStartRecording,
            onVerticalDragUpdate: _handleStartRecording,
            onHorizontalDragUpdate: _handleStartRecording,
            onLongPressUp: _handleStopRecording,
            onTapUp: (details) => _handleStopRecording(),
            onVerticalDragEnd: (details) => _handleStopRecording(),
            onHorizontalDragEnd: (details) => _handleStopRecording(),
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
      ),
    );
  }

  void _handleStartRecording(details) {
    if (!_isRecord) {
      showDialog(
        barrierColor: Colors.black.withOpacity(0.75),
        context: context,
        builder: (context) {
          double width = MediaQuery.of(context).size.width;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ClipRRect(
                    key: _recordingCancelBtnKey,
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: _recordCancelBtn ? Colors.black26 : Colors.black38,
                    ),
                  ),
                  Text('$_recordCancelBtn')
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(60),
                  //   child: Container(
                  //     width: 60,
                  //     height: 60,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: width,
                height: 140,
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        '松开 发送',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.72),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Positioned(
                      key: _recordingSendBtnKey,
                      top: 40,
                      left: -(width * 0.5 / 2),
                      child: ClipOval(
                        child: Container(
                          width: width * 1.5,
                          height: 400,
                          color:
                              _recordSendBtn ? Colors.black26 : Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      );
    }

    final recordSendBtn =
        _widgetCoincide(_recordingSendBtnKey, details.globalPosition, 1);

    final recordCancelBtn =
        _widgetCoincide(_recordingCancelBtnKey, details.globalPosition, 2);

    setState(() {
      _recordSendBtn = recordSendBtn;
      _recordCancelBtn = recordCancelBtn;
      _isRecord = true;
    });
  }

  void _handleStopRecording() {
    setState(() {
      _recordSendBtn = false;
      _recordCancelBtn = false;
      _isRecord = false;
    });
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
    // if (type == 2) {
    //   print('===== x = $x, y = $y, sizeW = $sizeW');
    //   print('===== boxX = $boxX, boxY = $boxY, sizeH = $sizeH');
    // }
    return coincide;
  }
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
}
