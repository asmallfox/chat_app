import 'package:chat_app/Helpers/find_data.dart';
import 'package:chat_app/Screens/Message/chat.dart';
import 'package:chat_app/Screens/Mine/mine.dart';
import 'package:chat_app/constants/config.dart';
import 'package:chat_app/provider/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final pageConfig = {
  '1': {
    'child': (Map<dynamic, dynamic> chatItem) => Chat(chatItem: chatItem),
  }
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
        try {
          final payload = notificationResponse.payload;

          if (payload != null) {
            final payloadArr = payload.split(',');

            final type = payloadArr[0];
            final friendId = int.parse(payloadArr[1]);

            final friend = findChatItem(friendId) ?? findFriend(friendId);
            final context =  navigatorKey.currentContext!;
            switch (type) {
              // 私信
              case '1':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chat(chatItem: friend!),
                  ),
                );
                break;
              default:
                print('没有匹配到推送的类型操作哟~');
                break;
            }
          }
        } catch (e) {
          print('错误： $e');
        }
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
