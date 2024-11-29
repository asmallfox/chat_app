import 'dart:async';

import 'package:chat_app/src/constants/global_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  static Future<void> showToast({
    BuildContext? context,
    required String message,
    int duration = 2,
    bool autoClose = true,
  }) {
    return showDialog(
      context: appNavigatorKey.currentContext!,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (content) {
        if (autoClose) {
          Future.delayed(Duration(seconds: duration), () {
            Navigator.pop(content);
          });
        }
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.shade400,
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showRequestToastError(Object error) async {
    if (error is Map) {
      await showToast(message: error['message']);
    }
  }

  static Future<void> showDialogModel({
    required Widget child,
    String? title,
    List<Widget>? actions,
    String? confirmBtnText,
    String? cancelBtnText,
    Function? confirm,
    Function? cancel,
  }) {
    return showDialog(
      context: appNavigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title == null ? null : Text(title),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          content: child,
          actions: actions ??
              <Widget>[
                TextButton(
                  child: Text(cancelBtnText ?? '取消'),
                  onPressed: () {
                    if (cancel == null) {
                      Navigator.of(context).pop();
                    } else {
                      cancel();
                    }
                  },
                ),
                FilledButton(
                  onPressed: () {
                    if (confirm == null) {
                      Navigator.of(context).pop();
                    } else {
                      confirm();
                    }
                  },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  child: Text(confirmBtnText ?? '确定'),
                ),
              ],
        );
      },
    );
  }
}
