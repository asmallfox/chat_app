import 'package:chat_app/src/constants/global_key.dart';
import 'package:flutter/material.dart';

void showToast({
  BuildContext? context,
  required String message,
  int duration = 2,
  bool autoClose = true,
}) {
  final ctx = context ?? appNavigatorKey.currentContext!;
  showDialog(
    context: ctx,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (content) {
      if (autoClose) {
        Future.delayed(Duration(seconds: duration), () {
          Navigator.pop(ctx);
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
