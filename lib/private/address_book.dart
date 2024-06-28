import 'package:flutter/material.dart';

class User {
  final String id;
  final int user1_id;
  final int user2_id;
  final int promoter_id;
  final int status;
  final int last_operator;
  final int created_at;
  final int updated_at;
  final int friendId;
  final String avatar;
  final String username;
  final String nickname;

  User({
    required this.id,
    required this.user1_id,
    required this.user2_id,
    required this.promoter_id,
    required this.status,
    required this.last_operator,
    required this.created_at,
    required this.updated_at,
    required this.friendId,
    required this.avatar,
    required this.username,
    required this.nickname,
  });
}

class AddressBookModel extends ChangeNotifier {
  final List<User> _userList = [];

  List<User> get userList => _userList;

  void add(User item) {
    _userList.add(item);
    notifyListeners();
  }

  void addAll(List<User> list) {
    _userList.addAll(list);
    notifyListeners();
  }

  void delete(User item) {
    _userList.remove(item);
    notifyListeners();
  }

  void removeAll() {
    _userList.clear();
    notifyListeners();
  }
}
