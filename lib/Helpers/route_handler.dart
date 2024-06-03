import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class HandleRoute {
  static Route? handleRoute(String? url) {
    Logger.root.info('收到的路由url: $url');

    if (url == null) return null;

    // final RegExpMatch? fileResult = RegExp(r'\/[0-9]+\/([0-9]+)\/').firstMatch('$url/');

    // if (fileResult != null) {
    //   return PageRouteBuilder(pageBuilder: (_, __, ___) {
    //     return null;
    //   });
    // }

    return PageRouteBuilder(pageBuilder: (_, __, ___) {
      return Text('123');
    });
  }
}
