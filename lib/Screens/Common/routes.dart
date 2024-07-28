import 'package:chat_app/Screens/Home/home.dart';
import 'package:chat_app/Screens/Login/login.dart';
import 'package:chat_app/Screens/Message/chat_audio_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

Widget initialFunction() {
  // return Hive.box('settings').get('token') != null
  //     ? const HomePage()
  //     : const LoginPage();
  return ChatAudioPage();
}

final Map<String, Widget Function(BuildContext)> namesRoutes = {
  '/': (context) => initialFunction()
};
