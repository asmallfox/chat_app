import 'package:flutter/material.dart';

class CommunicateIconButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color color;
  final VoidCallback? onTap;
  final TextStyle? style;

  const CommunicateIconButton({
    super.key,
    required this.icon,
    this.label,
    this.color = Colors.black,
    this.style,
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
              color: Colors.black.withOpacity(0.48),
              border: Border.all(
                width: 2,
                color: color.withOpacity(0.42),
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
                style: style ??
                    TextStyle(
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
