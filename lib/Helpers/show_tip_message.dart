import 'package:flutter/material.dart';

void showTipMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating, // 设置为 floating behavior
    ),
  );
}
