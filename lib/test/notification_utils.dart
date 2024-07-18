import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int id = 0;
  /// main 初始化
  init() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        print(
            'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx $notificationResponse');
      },
    );
  }

  void send() {
    print('通知 send 函数');
    const android = AndroidNotificationDetails(
      'channel id',
      'channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    // iOS平台的通知设置
    // var iOS = IOSNotificationDetails();

    const platform = NotificationDetails(
      android: android,
    );

    flutterLocalNotificationsPlugin.show(
      id++,
      '来电通知',
      'body',
      platform,
      payload: 'Welcome to Flutter Local Notifications',
    );
  }
}

var notification = Notification();
