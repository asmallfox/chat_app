import 'dart:async';

import 'package:chat_app/src/constants/global_key.dart';
import 'package:flutter/material.dart';

enum ModelType { success, error, info, warning }

IconData getIconByType(ModelType type) {
  switch (type) {
    case ModelType.success:
      return Icons.check;
    case ModelType.error:
      return Icons.error;
    case ModelType.info:
      return Icons.info;
    case ModelType.warning:
      return Icons.warning;
    default:
      return Icons.info;
  }
}

class MessageHelper {
  static Timer? _timer;

  static Future<void> showModel({
    required String message,
    IconData? icon,
    ModelType type = ModelType.info,
    bool hideIcon = false,
    int decoration = 1500,
  }) {
    return showDialog(
      context: appNavigatorKey.currentContext!,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        _timer = Timer(Duration(milliseconds: decoration), hideModel);

        return Align(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            constraints: const BoxConstraints(
              minWidth: 120,
              minHeight: 120,
            ),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: !hideIcon,
                  child: Icon(
                    getIconByType(type),
                    color: Colors.grey[350],
                    size: 50,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey[350],
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static hideModel() {
    _timer?.cancel();
    _timer = null;
    Navigator.of(appNavigatorKey.currentContext!).pop();
  }
}
