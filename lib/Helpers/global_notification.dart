import 'package:chat_app/Screens/Message/chat.dart';
import 'package:chat_app/constants/config.dart';
import 'package:chat_app/provider/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final pageConfig = {
  '1': {'child': Chat(chatItem: ChatModelProvider().chat!)}
};

class GlobalNotification {
  static final GlobalNotification _instance = GlobalNotification._internal();

  factory GlobalNotification() {
    return _instance;
  }

  GlobalNotification._internal();

  static bool _isInitialized = false;
  static late FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
  int id = 0;

  static Future<GlobalNotification> getInstance() async {
    if (!_isInitialized) {
      await _initialize();
    }
    return _instance;
  }

  // main 初始化
  static Future _initialize() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin?.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        selectNotificationStream.add(notificationResponse.payload);

        final item = pageConfig[notificationResponse.payload];

        if (item != null) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => item['child'] as Widget),
          );
        }

        print('处理 ${notificationResponse.payload}');
      },
    );
    _isInitialized = true;
  }

  void send(Map data) {
    const android = AndroidNotificationDetails(
      'channel id',
      'channel name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      // timeoutAfter: 3000,
    );

    // iOS平台的通知设置
    // var iOS = IOSNotificationDetails();

    const platform = NotificationDetails(
      android: android,
    );

    _flutterLocalNotificationsPlugin?.show(
      id++,
      data['title'] ?? '通知',
      data['body'] ?? 'body',
      platform,
      payload: data['payload'],
    );
  }
}
