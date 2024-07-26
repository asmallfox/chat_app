import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/Helpers/util.dart';

Map<dynamic, dynamic>? findFriend(
  dynamic value, [
  List<String>? excludeKey,
]) {
  final friends = LocalStorage.getUserBox().get('friends', defaultValue: []);

  Map<dynamic, dynamic>? result = listFind(
    friends,
    (item) => item['friendId'] == value,
  );

  if (result != null && excludeKey != null && excludeKey.isNotEmpty) {
    result.removeWhere((key, value) => excludeKey.contains(key));
  }

  return result;
}
