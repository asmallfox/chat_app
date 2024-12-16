import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class KeyBoardObserver extends WidgetsBindingObserver {
  double keyboardHeight = 0;
  double preHeight = 0;
  bool? isKeyboardShow;
  bool? isOpening;

  static const KEYBOARD_MAX_HEIGHT = 'keyboard_max_height';

  KeyBoardObserver._() {
    _getHeightToHive();
    WidgetsBinding.instance.addObserver(this);
  }

  static final KeyBoardObserver _instance = KeyBoardObserver._();
  static KeyBoardObserver get instance => _instance;

  @override
  void didChangeMetrics() {
    final bottom =
        MediaQueryData.fromView(PlatformDispatcher.instance.views.first)
            .viewInsets
            .bottom;

    keyboardHeight = max(keyboardHeight, bottom);

    if (bottom == 0) {
      isKeyboardShow = false;
    } else if (keyboardHeight == bottom) {
      isKeyboardShow = true;
    } else {
      isKeyboardShow = null;
    }

    if (isKeyboardShow != null && keyboardHeight != 0) {
      _saveKeyboardHeight();
    }
  }

  void _getHeightToHive() async {
    keyboardHeight =
        await Hive.box('app').get(KEYBOARD_MAX_HEIGHT, defaultValue: 0.0);
  }

  Future<void> _saveKeyboardHeight() async {
    Hive.box('app').put(KEYBOARD_MAX_HEIGHT, keyboardHeight);
  }
}
