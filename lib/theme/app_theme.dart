import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppTheme {
  static ThemeData lightTheme({required BuildContext context}) {
    return ThemeData(
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: const Color.fromARGB(255, 73, 63, 248),
            // primary: const Color(0xFF231C9D),
            brightness: Brightness.light,
            secondary: const Color(0xFF231C9D),
          ),
    );
  }

  static ThemeData darkTheme({required BuildContext context}) {
    return ThemeData(
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Colors.white,
            brightness: Brightness.dark,
            secondary: Colors.white,
          ),
    );
  }
}
