import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/Helpers/route_handler.dart';
import 'package:chat_app/Screens/Common/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:get_it/get_it.dart';
// GetIt getIt = GetIt.instance();

Future<void> main() async {
  // 返回实现 WidgetsBinding 的绑定的实例。
  // 如果尚未初始化绑定，则使用 WidgetsFlutterBinding 类创建和初始化绑定。
  WidgetsFlutterBinding.ensureInitialized();

  await initServer();

  runApp(const MyApp());
}

Future<void> initServer() async {
  await LocalStorage.getInstance();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: PageLayout(),
      routes: namesRoutes,
      onGenerateRoute: (RouteSettings settings) {
        print('路由守卫：${settings}');
        return HandleRoute.handleRoute(settings.name);
      },
    );
  }
}
