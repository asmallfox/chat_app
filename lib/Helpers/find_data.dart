import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/Helpers/util.dart';

Map<dynamic, dynamic>? findDataItem(
  List<dynamic> data,
  String key,
  dynamic value, [
  List<String>? excludeKey,
]) {
  Map<dynamic, dynamic>? result = listFind(
    data,
    (item) => item[key] == value,
  );

  if (result != null && excludeKey != null && excludeKey.isNotEmpty) {
    result.removeWhere((key, value) => excludeKey.contains(key));
  }

  return result;
}

// 查找好友
Map<dynamic, dynamic>? findFriend(
  dynamic value, [
  List<String>? excludeKey,
]) {
  final friends = LocalStorage.getUserBox().get('friends', defaultValue: []);

  return findDataItem(friends, 'friendId', value, excludeKey);
}

// 查找聊天
Map<dynamic, dynamic>? findChatItem(
  dynamic value, [
  List<String>? excludeKey,
]) {
  final chatList = LocalStorage.getUserBox().get('chatList', defaultValue: []);

  return findDataItem(chatList, 'friendId', value, excludeKey);
}
