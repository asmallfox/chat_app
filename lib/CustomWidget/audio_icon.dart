import 'dart:math';

import 'package:flutter/material.dart';

class AudioIconPaint extends CustomPainter {
  final Color actionColor;
  final int actionIndex;

  AudioIconPaint({
    this.actionColor = Colors.black,
    this.actionIndex = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint arcPaint = Paint()
      ..color = actionIndex > 0 ? actionColor : Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: const Offset(0, 20), radius: 3.5),
      0,
      pi * 2,
      false,
      arcPaint,
    );

    Paint paint_1 = Paint()
      ..color = actionIndex > 1 ? actionColor : Colors.black
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    Path path_1 = Path();
    path_1.moveTo(5, 12);
    path_1.quadraticBezierTo(
      13,
      20,
      5,
      28,
    );

    canvas.drawPath(path_1, paint_1);

    Paint paint_2 = Paint()
      ..color = actionIndex > 2 ? actionColor : Colors.black
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    Path path_2 = Path();
    path_2.moveTo(11, 8);
    path_2.quadraticBezierTo(
      22,
      20,
      11,
      32,
    );

    canvas.drawPath(path_2, paint_2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is AudioIconPaint) {
      return oldDelegate.actionIndex != actionIndex;
    }
    return true;
  }
}

class AudioIcon extends StatefulWidget {
  final bool isPlay;

  const AudioIcon({
    super.key,
    this.isPlay = false,
  });

  @override
  State<AudioIcon> createState() => _AudioIconState();
}

class _AudioIconState extends State<AudioIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.isPlay) {
          startAnimation();
        } else {
          // Timer(const Duration(milliseconds: 80), () {
          // });
          _controller.value = 0;
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    _controller.reset(); // 重置动画的状态
    _controller.forward(); // 启动动画
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ValueNotifier(widget.isPlay),
      builder: (content, value, child) {
        if (value) {
          startAnimation();
        }
        return child!;
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext content, Widget? child) {
          int index = (_controller.value * 10 / 3).floor();

          return CustomPaint(
            size: const Size(24, 38),
            painter: AudioIconPaint(
              // actionColor: Theme.of(context).colorScheme.primary,
              actionColor: Colors.red,
              actionIndex: index,
            ),
          );
        },
      ),
    );
  }
}
