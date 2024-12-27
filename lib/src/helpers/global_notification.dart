import 'dart:io';

import 'package:chat_app/constants/config.dart';
import 'package:chat_app/src/constants/global_key.dart';
import 'package:chat_app/src/pages/layout/chats/chats_audio.page.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

class GlobalNotification {
  static final GlobalNotification _instance = GlobalNotification._internal();

  factory GlobalNotification() => _instance;

  GlobalNotification._internal();

  static bool _isInitialized = false;
  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  static int _id = 0;

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

            final type = int.parse(payloadArr[0]);
            final friendId = int.parse(payloadArr[1]);

            final context = appNavigatorKey.currentContext!;
            final friend = UserHive.getFriend(id: friendId);

            if (friend == null) return;

            switch (type) {
              // 私信
              case 1:
              case 2:
                print('推送被点击了');
                break;
              case 3:
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ChatsAudioPage(friend: friend),
                  ),
                );
                break;
              default:
                print('没有匹配到推送的类型操作~');
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

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  // static Future<void> _showBigPictureNotification() async {
  //   final String largeIconPath =
  //       await _downloadAndSaveFile('https://dummyimage.com/48x48', 'largeIcon');
  //   final String bigPicturePath = await _downloadAndSaveFile(
  //       'https://dummyimage.com/400x800', 'bigPicture');
  //   final BigPictureStyleInformation bigPictureStyleInformation =
  //       BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
  //           largeIcon: FilePathAndroidBitmap(largeIconPath),
  //           contentTitle: 'overridden <b>big</b> content title',
  //           htmlFormatContentTitle: true,
  //           summaryText: 'summary <i>text</i>',
  //           htmlFormatSummaryText: true);
  //   final AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //           'big text channel id', 'big text channel name',
  //           channelDescription: 'big text channel description',
  //           styleInformation: bigPictureStyleInformation);
  //   final NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);
  //   await _flutterLocalNotificationsPlugin?.show(
  //     _id++,
  //     'big text title',
  //     'silent body',
  //     notificationDetails,
  //   );
  // }

  static Future<void> send(Map data) async {
    const bigPictureStyle = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap(
          'https://img2.baidu.com/it/u=1337068678,3064275007&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=750'), // 设置图片
      // largeIcon: DrawableResourceAndroidBitmap('https://img2.baidu.com/it/u=1337068678,3064275007&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=750'), // 设置大图标
    );

    // const androidDetails = AndroidNotificationDetails(
    //     'channel id', 'channel name',
    //     importance: Importance.max,
    //     priority: Priority.high,
    //     ticker: 'ticker',
    //     channelDescription: 'Your channel description',
    //     styleInformation: bigPictureStyle,
    //     enableVibration: true,
    //     playSound: true,
    //     actions: [
    //       AndroidNotificationAction('2', '拒绝'),
    //       AndroidNotificationAction('3', '接听'),
    //     ]);
    // const androidDetails = AndroidNotificationDetails(
    //   'channel id',
    //   'channel name',
    //   importance: Importance.max,
    //   priority: Priority.high,
    //   ticker: 'ticker',
    //   channelDescription: 'Your channel description',
    //   styleInformation: BigPictureStyleInformation(
    //     DrawableResourceAndroidBitmap('default_avatar'), // 左边显示头像（头像的图片资源）
    //     contentTitle: 'Notification Title',
    //     summaryText: 'This is a summary of the notification',
    //   ),
    //   enableVibration: true,
    //   playSound: true,
    //   actions: <AndroidNotificationAction>[
    //     // 圆形拒接按钮
    //     AndroidNotificationAction('2', '拒接'),
    //     // 圆形接通按钮
    //     AndroidNotificationAction('3', '接通'),
    //   ],
    // );

    // iOS平台的通知设置
    // var iOS = IOSNotificationDetails();

    // const platform = NotificationDetails(
    //   android: androidDetails,
    // );

    // _flutterLocalNotificationsPlugin?.show(
    //   _id++,
    //   data['title'] ?? '',
    //   data['body'] ?? '',
    //   platform,
    //   // payload: data['payload'],
    // );

    // final String largeIconPath =
    //     await _downloadAndSaveFile('https://dummyimage.com/48x48', 'largeIcon');

    // final String bigPicturePath = await _downloadAndSaveFile(
    //     'https://dummyimage.com/400x800', 'bigPicture');

    // final BigPictureStyleInformation bigPictureStyleInformation =
    //     BigPictureStyleInformation(
    //   FilePathAndroidBitmap(bigPicturePath),
    //   largeIcon: FilePathAndroidBitmap(largeIconPath),
    //   // contentTitle: 'overridden <b>big</b> content title',
    //   htmlFormatContentTitle: true,
    //   // summaryText: 'summary <i>text</i>',
    //   htmlFormatSummaryText: true,
    // );

    final String bigPicture = await _downloadAndSaveFile(
        'https://dummyimage.com/40x40', 'bigPicture');
    final String largeIconPath =
        await _downloadAndSaveFile('https://dummyimage.com/48x48', 'largeIcon');

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel id',
      'channel name',
      // icon: 'default_avatar',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      timeoutAfter: 3000,
      showWhen: false,
      usesChronometer: false,
      chronometerCountDown: false,
      ongoing: true,
      visibility: NotificationVisibility.public,
      enableVibration: false,
      largeIcon: const DrawableResourceAndroidBitmap('default_avatar'),
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin?.show(
      _id++,
      'title',
      'body',
      notificationDetails,
      payload: 'xxxxxxxxxxxxx',
    );
  }

  static Future<void> show(
    Map data, {
    String? title,
    String? body,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel id',
      'channel name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      timeoutAfter: 3000,
      showWhen: false,
      usesChronometer: false,
      chronometerCountDown: false,
      ongoing: true,
      visibility: NotificationVisibility.public,
      enableVibration: false,
      largeIcon: const DrawableResourceAndroidBitmap('default_avatar'),
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin?.show(
        _id++, title ?? '', body ?? '', notificationDetails,
        payload: '${data['type']},${data['user']['id']}');
  }
}
