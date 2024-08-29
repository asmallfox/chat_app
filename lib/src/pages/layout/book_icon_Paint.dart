import 'dart:math';

import 'package:flutter/material.dart';

class BookIconPaint extends CustomPainter {
  final String? label;
  BookIconPaint({
    this.label,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    const offsetRation = 0.625;
    final hCenter = size.height / 2;

    final path1 = Path()
      ..moveTo(size.width, hCenter)
      ..quadraticBezierTo(size.width * offsetRation, 0, hCenter, 0)
      ..lineTo(hCenter, size.height)
      ..quadraticBezierTo(
          size.width * offsetRation, size.height, size.width, hCenter)
      ..close();

    final path2 = Path()
      ..addArc(
        Rect.fromCircle(center: Offset(hCenter, hCenter), radius: hCenter),
        0,
        2 * pi,
      )
      ..close();
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);

    // 绘制文字
    if (label != null) {
      print('=============== $label');
      final textSize = size.height * 0.65;
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.white,
            fontSize: textSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.start,
        textDirection: TextDirection.ltr,
      );

      // 计算文本的大小
      textPainter.layout();

      // 在画布上绘制文本
      textPainter.paint(
        canvas,
        Offset(
          (size.height - textPainter.width) / 2,
          (size.height - textPainter.height) / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is BookIconPaint) {}
    return true;
  }
}
