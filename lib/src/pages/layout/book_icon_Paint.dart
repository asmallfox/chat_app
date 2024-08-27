import 'dart:math';

import 'package:flutter/material.dart';

class BookIconPaint extends CustomPainter {
  BookIconPaint();

  @override
  void paint(Canvas canvas, Size size) {
    Paint arcPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: const Offset(0, 20), radius: 3.5),
      0,
      pi * 2,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is BookIconPaint) {}
    return true;
  }
}

class AddressBookIcon extends StatefulWidget {
  const AddressBookIcon({
    super.key,
  });

  @override
  State<AddressBookIcon> createState() => _AddressBookIconState();
}

class _AddressBookIconState extends State<AddressBookIcon>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 38),
      painter: BookIconPaint(),
    );
  }
}
