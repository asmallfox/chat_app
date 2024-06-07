import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppTheme {
  static ThemeData lightTheme({required BuildContext context}) {
    return ThemeData(
      primarySwatch: Colors.blue,
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: const Color(0xFF231C9D),
            brightness: Brightness.light,
            // secondary:
          ),
    );
  }
}
