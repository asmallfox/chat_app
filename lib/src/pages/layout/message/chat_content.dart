import 'dart:math';

import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final double offset; // 动态偏移量

  const WavePainter({
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()..color = Colors.blue;
    final Rect rect = Offset.zero & size;
    canvas.drawRect(rect, backgroundPaint);

    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    Path path = Path();

    // 计算波浪线的起点
    double waveHeight = 20; // 波浪高度
    double waveLength = 100; // 波浪长度

    // 从左边开始
    path.moveTo(0, size.height / 2);

    // 画波浪线
    for (double x = 0; x <= size.width + waveLength; x += waveLength) {
      path.quadraticBezierTo(
        x + waveLength / 4,
        size.height / 2 -
            waveHeight * (0.5 + 0.5 * sin(offset + x / waveLength)),
        x + waveLength / 2,
        size.height / 2,
      );
      path.quadraticBezierTo(
        x + 3 * waveLength / 4,
        size.height / 2 +
            waveHeight * (0.5 + 0.5 * sin(offset + x / waveLength)),
        x + waveLength,
        size.height / 2,
      );
    }

    // 绘制路径
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// class WavePainter extends CustomPainter {
//   final double offset; // 动态偏移量

//   const WavePainter({
//     required this.offset,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint backgroundPaint = Paint()..color = Colors.blue;
//     final Rect rect = Offset.zero & size;
//     canvas.drawRect(rect, backgroundPaint);

//     Paint paint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3;

//     Path path = Path();

//     // 计算波浪线的起点
//     double waveHeight = 20; // 波浪高度
//     double waveLength = 100; // 波浪长度

//     // 从左边开始
//     path.moveTo(0, size.height / 2);

//     // 画波浪线
//     for (double x = 0; x <= size.width; x += 1) {
//       // 使用sin函数计算y坐标
//       double y = size.height / 2 +
//           waveHeight * sin((x / waveLength) * (2 * pi) + offset);
//       path.lineTo(x, y); // 绘制到新的点
//     }

//     // 绘制路径
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }

class ChatContent extends StatefulWidget {
  const ChatContent({
    super.key,
  });

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // 动画持续时间
      vsync: this,
    )..repeat(reverse: false); // 无限循环

    // 创建动画，控制波浪线的偏移
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);

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
              size: const Size(300, 100),
              painter: WavePainter(
                offset: _animation.value,
              ),
            ),
          );
        },
      ),
    );
    // return Container(
    //   alignment: Alignment.center,
    //   child: ClipRect(
    //     child: CustomPaint(
    //       size: const Size(300, 100),
    //       painter: VoiceIcon(
    //         offset: _animation.value,
    //       ),
    //     ),
    //   ),
    // );
    // return ListView.builder(
    //   controller: _scrollController,
    //   itemCount: 20,
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       leading: CircleAvatar(
    //         backgroundColor: Colors.blue,
    //         child: Text("A ${index}"),
    //       ),
    //       title: Text('Hello, World!'),
    //       subtitle: Text('This is a sample message.'),
    //     );
    //   },
    // );
  }
}
