import 'package:flutter/material.dart';

class ChatBubbleMenuItem extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final double width;
  final double height;
  final double iconSize;

  const ChatBubbleMenuItem({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.width,
    required this.height,
    this.iconSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          maxWidth: width,
          minHeight: height,
        ),
        onPressed: onPressed,
        icon: icon,
        iconSize: iconSize,
      ),
    );
  }
}