import 'dart:io';

import 'package:chat_app/Helpers/audio_serice.dart';
import 'package:chat_app/Helpers/logging.dart';
import 'package:chat_app/Helpers/route_handler.dart';
import 'package:chat_app/provider/model/chat_model.dart';
import 'package:chat_app/provider/provider.dart';
import 'package:chat_app/socket/socket_io.dart';
import 'package:chat_app/Screens/Common/routes.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

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

  final userBox = Hive.box('settings').get('users', defaultValue: []);
  print(userBox);
  if (userBox.length > 0) {
    for (final id in userBox) {
      await openHive(
        'user_$id',
        limit: false,
      );
    }
  }

  await startService();

  // runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChatModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> startService() async {
  // await initializeLogging();

  await SocketIOClient.getInstance();
  await RecordingManager.getInstance();
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
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme(context: context),
      darkTheme: AppTheme.darkTheme(context: context),
    );
  }
}
