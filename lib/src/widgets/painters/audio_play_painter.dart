import 'dart:math';

import 'package:flutter/material.dart';

class AudioPlayIconPaint extends CustomPainter {
  final Color actionColor;
  final Color inactiveColor;
  final int actionIndex;

  AudioPlayIconPaint({
    this.actionColor = Colors.black,
    this.inactiveColor = Colors.white,
    this.actionIndex = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double radius = 3.5;
    double centerY = size.height / 2;

    Paint arcPaint = Paint()
      ..color = actionIndex > 0 ? actionColor : inactiveColor
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(0, centerY), radius: radius),
      0,
      pi * 2,
      false,
      arcPaint,
    );

    Paint paint_1 = Paint()
      ..color = actionIndex > 1 ? actionColor : inactiveColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    Path path_1 = Path();
    path_1.moveTo(radius, centerY - radius * 2);
    path_1.quadraticBezierTo(
      radius * 4,
      centerY,
      radius,
      centerY + radius * 2,
    );

    canvas.drawPath(path_1, paint_1);

    Paint paint_2 = Paint()
      ..color = actionIndex > 2 ? actionColor : inactiveColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    Path path_2 = Path();
    path_2.moveTo(radius * 3, centerY - radius * 3);
    path_2.quadraticBezierTo(
      radius * 6,
      centerY,
      radius * 3,
      centerY + radius * 3,
    );

    canvas.drawPath(path_2, paint_2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is AudioPlayIconPaint) {
      return oldDelegate.actionIndex != actionIndex;
    }
    return true;
  }
}
