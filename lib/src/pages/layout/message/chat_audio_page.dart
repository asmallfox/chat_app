import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ChatAudioPage extends StatefulWidget {
  final Map friend;

  const ChatAudioPage({
    super.key,
    required this.friend,
  });

  @override
  State<ChatAudioPage> createState() => _ChatAudioPageState();
}

class _ChatAudioPageState extends State<ChatAudioPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 模糊效果
        Positioned.fill(
          child: Image.asset(
            'assets/images/default_avatar.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: const SizedBox(),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              widget.friend['name'],
              style: const TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.grey.shade500,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text('xx'),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    CommunicateIcon(
                      label: '免提',
                      color: Colors.grey.shade400,
                      icon: Icons.volume_off_rounded,
                      onTap: () {},
                    ),
                    CommunicateIcon(
                      label: '麦克风',
                      color: Colors.grey.shade400,
                      icon: Icons.mic_none_rounded,
                      onTap: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CommunicateIcon extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color color;
  final VoidCallback? onTap;

  const CommunicateIcon({
    super.key,
    required this.icon,
    this.label,
    this.color = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: color,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              size: 40,
              color: color,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: label != null,
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 24,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
