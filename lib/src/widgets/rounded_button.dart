import 'package:flutter/material.dart';

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

