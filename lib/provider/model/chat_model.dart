import 'package:flutter/material.dart';

class ChatModel extends ChangeNotifier {
  static Map? staticCurrentChat;

  Map? _currentChat;

  Map? get currentChat => _currentChat;

  void setChat(Map chat) {
    staticCurrentChat = chat;
    _currentChat = chat;
    notifyListeners();
  }

  void removeChat() {
    _currentChat = null;
    staticCurrentChat = null;
  }
}
