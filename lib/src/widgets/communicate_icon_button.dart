import 'package:flutter/material.dart';

class CommunicateIconButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color color;
  final VoidCallback? onTap;

  const CommunicateIconButton({
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
