import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

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
  // 正在通话
  bool isOnCall = false;
  // 扩音
  bool isExpanded = false;
  // 静音
  bool isMuted = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            widget.friend['avatar'],
            fit: BoxFit.cover,
          ),
        ),
        // 模糊效果
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.68),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 32, sigmaY: 32),
            child: const SizedBox(),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.grey.shade500,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      widget.friend['avatar'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 免提
                    Visibility(
                      visible: isOnCall,
                      child: CommunicateIcon(
                        color: Colors.grey.shade300,
                        icon: Icons.volume_off_rounded,
                        onTap: () {},
                      ),
                    ),
                    RoundedButton(
                      icon: Icons.local_phone_rounded,
                      color: Colors.white,
                      backgroundColor: Colors.red,
                      onPressed: () {
                        setState(() {
                          isOnCall = false;
                        });
                        // Navigator.of(context).pop();
                      },
                    ),
                    Visibility(
                      visible: !isOnCall,
                      child: RoundedButton(
                        icon: Icons.local_phone_rounded,
                        color: Colors.white,
                        backgroundColor: Colors.green,
                        onPressed: () {
                          setState(() {
                            isOnCall = true;
                          });
                        },
                      ),
                    ),
                    // 静音
                    Visibility(
                      visible: isOnCall,
                      child: CommunicateIcon(
                        color: Colors.grey.shade300,
                        icon: isMuted ? Icons.mic_external_off_rounded : Icons.mic_none_rounded,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RoundedButton extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  const RoundedButton({
    super.key,
    required this.icon,
    this.size = 48,
    this.color = Colors.black,
    this.backgroundColor = Colors.white,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: color,
        size: size,
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(backgroundColor),
      ),
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
          Visibility(
            visible: label != null,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                label ?? '',
                style: TextStyle(
                  fontSize: 24,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
