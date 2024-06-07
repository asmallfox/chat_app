import 'dart:io';

import 'package:chat_app/Helpers/logging.dart';
import 'package:chat_app/Helpers/route_handler.dart';
import 'package:chat_app/Helpers/socket_io.dart';
import 'package:chat_app/Screens/Common/routes.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // 返回实现 WidgetsBinding 的绑定的实例。
  // 如果尚未初始化绑定，则使用 WidgetsFlutterBinding 类创建和初始化绑定。
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await Hive.initFlutter('ChatApp/Database');
  } else if (Platform.isIOS) {
    await Hive.initFlutter('Database');
  } else {
    await Hive.initFlutter();
  }

  for (final box in hiveBoxes) {
    await openHive(
      box['name'].toString(),
      limit: box['limit'] as bool,
    );
  }

  await startService();

  runApp(const MyApp());
}

Future<void> startService() async {
  await initializeLogging();

  await SocketIO.getInstance();

  // GetIt getIt = GetIt.instance;
  // getIt.registerSingleton<AppModel>(AppModel());
  // GetIt.I.registerSingleton<AppModel>(AppModel());
}

Future<void> openHive(String boxName, {bool limit = false}) async {
  final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
    Logger.root.severe('无法打开 $boxName Box', error, stackTrace);
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = dir.path;
    File dbFile = File('$dirPath/$boxName.hive');
    File lockFile = File('$dir/$boxName.lock');

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dbFile = File('$dirPath/chat/$boxName.hive');
      lockFile = File('$dirPath/chat/$boxName.lock');
    }

    await dbFile.delete();
    await lockFile.delete();
    await Hive.openBox(boxName);

    throw '无法打开 $boxName Box\n: $error';
  });

  // 如果box超过最大值，则清除存储
  if (limit && box.length > 500) {
    box.clear();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: namesRoutes,
      onGenerateRoute: (RouteSettings settings) {
        return HandleRoute.handleRoute(settings.name);
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF231C9D),
        ),
        textTheme: const TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          )
        ),
      ),
    );
  }
}
