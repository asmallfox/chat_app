import 'package:flutter/material.dart';

class HandleRoute {
  static Route? handleRoute(String? url) {
    if (url == null) return null;

    return PageRouteBuilder(pageBuilder: (_, __, ___) {
      return const Text('xxxxx');
    });
  }
}
