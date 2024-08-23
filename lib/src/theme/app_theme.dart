import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppTheme {
  static ThemeData lightTheme({required BuildContext context}) {
    return ThemeData(
      colorScheme: Theme.of(context).colorScheme.copyWith(
            brightness: Brightness.light,
            primary: const Color(0xFF231c9d),
            // primary: const Color(0xFF493FF8),
            secondary: const Color(0xFF231C9D),
            tertiary: const Color(0xFF6C79F8),
            tertiaryContainer: const Color(0xFFeaebfd),
          ),
      highlightColor: Colors.transparent, // 长按效果
      splashColor: Colors.transparent, // 点击效果
    );
  }

  static ThemeData darkTheme({required BuildContext context}) {
    return ThemeData(
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Colors.white,
            brightness: Brightness.dark,
            secondary: Colors.white,
          ),
      highlightColor: Colors.transparent, // 长按效果
      splashColor: Colors.transparent, // 点击效果
    );
  }
}
