import 'package:flutter/material.dart';
import 'package:chat_app/Screens/Home/home.dart';
import 'package:chat_app/Helpers/AuthenticationWrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthenticationWrapper(),
    );
  }
}
