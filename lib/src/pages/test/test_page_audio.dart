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
                    .setSubscriptionDuration(Duration(milliseconds: 100));
                RecordingHelper.audioRecorder.onProgress?.listen((e) {
                  setState(() {
                    list.removeAt(0);
                    list.add(e.decibels!);
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
          // AudioCable(decibels: decibels),
          FilledButton(
            onPressed: () {},
            child: Text('按住说话'),
          ),
          FilledButton(
            onPressed: () {},
            child: Text('语音通话'),
          )
        ],
      ),
    );
  }
}

class AudioCable extends StatefulWidget {
  final double? decibels;
  const AudioCable({
    super.key,
    this.decibels = 10,
  });

  @override
  State<AudioCable> createState() => _AudioCableState();
}

class _AudioCableState extends State<AudioCable>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // 动画持续时间
      reverseDuration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double speed = 10;

    List<double> list = List.generate(20, (index) => 10);
    return ClipRect(
      child: CustomPaint(
        size: const Size(200, 100),
        painter: AudioCablePainter(
          list: list,
          decibels: widget.decibels,
          offset: _animation.value * speed,
        ),
      ),
    );

    // return Container(
    //   alignment: Alignment.topLeft,
    //   child: AnimatedBuilder(
    //     animation: _animation,
    //     builder: (context, child) {
    //       print(widget.decibels);
    //       list.removeAt(0);
    //       list.add(widget.decibels ?? 10);
    //       return ClipRect(
    //         child: CustomPaint(
    //           size: const Size(200, 100),
    //           painter: AudioCablePainter(
    //             list: list,
    //             decibels: widget.decibels,
    //             offset: _animation.value * speed,
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
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
