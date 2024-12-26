import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatProviderModel with ChangeNotifier {
  bool _isRecord = false;
  bool _recordSendBtn = false;
  bool _recordCancelBtn = false;
  List<double> _decibelsList = List<double>.generate(20, (index) => 4);

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

  List<double> get decibelsList => _decibelsList;
  void setDecibelsList(double decibels, [bool reset = false]) {
    if (reset) {
      _decibelsList = List<double>.generate(20, (index) => 4);
    } else {
      double val = decibels < 4 ? 4 : decibels;
      _decibelsList.removeAt(0);
      _decibelsList.add(val);
    }
    notifyListeners();
  }
}
