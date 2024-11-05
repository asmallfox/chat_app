import 'package:chat_app/src/pages/layout/layout_page.dart';
import 'package:chat_app/src/pages/login/log_on_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

Widget initialRouter() {

  final token = Hive.box('app').get('token');

  if (token == null) {
    return const LogOnPage();
  }

  return  const LayoutPage();
}

final Map<String, Widget Function(BuildContext)> namesRoutes = {
  '/': (context) => initialRouter(),
};
