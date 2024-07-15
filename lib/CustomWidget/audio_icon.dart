import 'dart:math';

import 'package:chat_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AudioIconPaint extends CustomPainter {
  final Color color;

  AudioIconPaint({
    this.color = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: const Offset(0, 20), radius: 3.5),
      0,
      pi * 2,
      false,
      arcPaint,
    );

    Paint paint_1 = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    Path path_1 = Path();
    path_1.moveTo(5, 12); // 顶部点
    path_1.quadraticBezierTo(
      13,
      20,
      5,
      28,
    ); // 左下角点

    canvas.drawPath(path_1, paint_1);

    Path path_2 = Path();
    path_2.moveTo(11, 8);
    path_2.quadraticBezierTo(
      22,
      20,
      11,
      32,
    );

    canvas.drawPath(path_2, paint_1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AudioIcon extends StatefulWidget {
  const AudioIcon({super.key});

  @override
  State<AudioIcon> createState() => _AudioIconState();
}

class _AudioIconState extends State<AudioIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late dynamic _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _colorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.red,
    ).animate(_controller);

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('动画颜色： ${_colorAnimation.value}');
    print('xxxxxx');
    return CustomPaint(
      size: const Size(40, 40),
      painter: AudioIconPaint(
        color: _colorAnimation.value,
      ),
    );
  }
}
