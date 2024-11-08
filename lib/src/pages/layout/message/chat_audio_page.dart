import 'package:flutter/material.dart';

class ChatAudioPage extends StatefulWidget {
  const ChatAudioPage({
    super.key,
  });

  @override
  State<ChatAudioPage> createState() => _ChatAudioPageState();
}

class _ChatAudioPageState extends State<ChatAudioPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'title',
              style: const TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              children: [
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
