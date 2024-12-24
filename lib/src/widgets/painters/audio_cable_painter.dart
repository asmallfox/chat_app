import 'package:flutter/material.dart';

class AudioCablePainter extends CustomPainter {
  final List<double> list;
  final double? defaultDecibels;
  AudioCablePainter({
    required this.list,
    this.defaultDecibels = 4,
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
