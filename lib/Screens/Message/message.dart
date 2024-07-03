import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/search_user_page.dart';
import 'package:chat_app/Helpers/animation_slide_route.dart';
import 'package:chat_app/Screens/Message/chat.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  final List<Map<String, dynamic>> userList = [];
  final List chatList = Hive.box('chat').get('chatList', defaultValue: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const SearchUserPage(),
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          var item = chatList[index];
          var newMessage = item['message'][item['message'].length - 1];
          int newMessageCount =
              item['newMessageCount'] > 99 ? 99 : item['newMessageCount'];

          return GestureDetector(
            key: ValueKey(item['friendId']),
            onTap: () {
              Navigator.push(context, animationSlideRoute(Chat(user: item)));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Avatar(
                    imageUrl: item['avatar'],
                    size: 50,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item['nickname'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Text(
                              getDateTime(newMessage['created_at']),
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            newMessage['type'] == 1
                                ? Text(
                                    "${newMessageCount > 0 ? '[$newMessageCount条] ' : ''}${newMessage['message']}",
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

String getDateTime(int date) {
  DateTime dataTime = DateTime.fromMillisecondsSinceEpoch(date * 1000);
  DateTime nowTime = DateTime.now();

  bool isYear = dataTime.year == nowTime.year;
  bool isMonth = isYear && dataTime.month == nowTime.month;

  int differDay = nowTime.day - dataTime.day;

  String time;

  if (isMonth) {
    switch (differDay) {
      case 0:
        time = DateFormat('HH:mm').format(dataTime);
        break;
      case 1:
        time = '昨天';
        break;
      case 2:
        time = '前天';
        break;
      default:
        time = DateFormat('MM-dd').format(dataTime);
    }
  } else if (isYear) {
    time = DateFormat('MM-dd').format(dataTime);
  } else {
    time = DateFormat('yyyy-MM-dd').format(dataTime);
  }
  return time;
}
