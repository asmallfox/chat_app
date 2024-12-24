import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatProviderModel with ChangeNotifier {
  bool _isRecord = false;
  bool _recordSendBtn = false;
  bool _recordCancelBtn = false;

  bool get isRecord => _isRecord;
  void setIsRecord(bool value) {
    _isRecord = value;
    notifyListeners();
  }

  bool get recordSendBtn => _recordSendBtn;
  void setRecordSendBtn(bool value) {
    _recordSendBtn = value;
    notifyListeners();
  }

  bool get recordCancelBtn => _recordCancelBtn;
  void setRecordCancelBtn(bool value) {
    _recordCancelBtn = value;
    notifyListeners();
  }
}
