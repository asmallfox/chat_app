import 'dart:math';

import 'package:flutter/material.dart';

class AudioCablePainter extends CustomPainter {
  final double offset; // 动态偏移量

  const AudioCablePainter({
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景
    Paint backgroundPaint = Paint()..color = Colors.blue;
    final Rect rect = Offset.zero & size;
    canvas.drawRect(rect, backgroundPaint);

    Paint paint = Paint()..color = Colors.white;

    for (int i = 0; i < 20; i++) {
      double height = Random().nextInt(15) * 2.0 * offset;
      RRect rRect = RRect.fromRectXY(
        Rect.fromCenter(center: Offset(i * 12, 50), width: 4, height: height),
        8,
        10,
      );
      canvas.drawRRect(rRect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class AudioCable extends StatefulWidget {
  const AudioCable({
    super.key,
  });

  @override
  State<AudioCable> createState() => _AudioCableState();
}

class _AudioCableState extends State<AudioCable>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _curvedAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // 动画持续时间
      vsync: this,
    )..repeat(reverse: false); // 无限循环

    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // 使用easeInOut曲线
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_curvedAnimation);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose(); // 释放资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return ClipRect(
            child: CustomPaint(
              size: const Size(200, 100),
              painter: AudioCablePainter(
                offset: _animation.value,
              ),
            ),
          );
        },
      ),
    );
  }
}
