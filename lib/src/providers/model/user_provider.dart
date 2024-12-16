import 'package:chat_app/src/utils/hive_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Map? _user;
  Map? _userInfo;
  List? _friends;
  List? _chatList;

  Map get user {
    if (_user == null) {
      return UserHive.userInfo;
    }

    return _user!;
  }

  void setUser(Map user) {
    _user = user;
    notifyListeners();
  }
}
