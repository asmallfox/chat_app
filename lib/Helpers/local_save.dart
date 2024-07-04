import 'package:hive/hive.dart';

Future<void> localSave(
  String boxName,
  String key,
  dynamic data,
) async {
  final box = Hive.box(boxName);

  await box.put(key, data);
}

// Future<void> localUpdate(key, data) {
// }
