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
  bool isOnCall = false;

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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible: false,
                      child: CommunicateIcon(
                        // label: '免提',
                        color: Colors.grey.shade300,
                        icon: Icons.volume_off_rounded,
                        onTap: () {},
                      ),
                    ),
                    RoundedButton(
                      icon: Icons.local_phone_rounded,
                      color: Colors.white,
                      backgtoundColor: Colors.red,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Offstage(
                      offstage: true,
                      child: RoundedButton(
                        icon: Icons.local_phone_rounded,
                        color: Colors.white,
                        backgtoundColor: Colors.green,
                        onPressed: () {
                          setState(() {
                            isOnCall = true;
                          });
                        },
                      ),
                    ),
                    Offstage(
                      offstage: isOnCall,
                      child: CommunicateIcon(
                        // label: '静音',
                        color: Colors.grey.shade300,
                        icon: Icons.mic_none_rounded,
                        onTap: () {},
                      ),
                    )
                    // CommunicateIcon(
                    //   label: '录音',
                    //   color: Colors.grey.shade400,
                    //   icon: Icons.mic_none_rounded,
                    //   onTap: () {},
                    // ),
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
  final Color backgtoundColor;
  final VoidCallback? onPressed;
  const RoundedButton({
    super.key,
    required this.icon,
    this.size = 48,
    this.color = Colors.black,
    this.backgtoundColor = Colors.white,
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
        backgroundColor: WidgetStatePropertyAll<Color>(backgtoundColor),
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
