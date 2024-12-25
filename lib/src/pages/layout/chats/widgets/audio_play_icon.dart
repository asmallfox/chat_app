import 'package:chat_app/src/widgets/painters/audio_play_painter.dart';
import 'package:flutter/material.dart';

class AudioPlayIcon extends StatefulWidget {
  final bool isPlay;
  final bool isSelf;
  const AudioPlayIcon({
    super.key,
    this.isPlay = false,
    this.isSelf = true,
  });

  @override
  State<AudioPlayIcon> createState() => _AudioPlayIconState();
}

class _AudioPlayIconState extends State<AudioPlayIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  void _startAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.isPlay) {
          _startAnimation();
        } else {
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ValueNotifier(widget.isPlay),
      builder: (context, value, child) {
        if (value) {
          _startAnimation();
        }
        return child!;
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          int index = (_controller.value * 10 / 3).floor();
          return CustomPaint(
            size: const Size(24, 24),
            painter: AudioPlayIconPaint(
              actionColor: Colors.red,
              actionIndex: index,
              inactiveColor: widget.isSelf ? Colors.white : Colors.black,
            ),
          );
        },
      ),
    );
  }
}
