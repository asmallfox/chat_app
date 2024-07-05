import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/search_user_page.dart';
import 'package:chat_app/Helpers/animation_slide_route.dart';
import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/Screens/Message/chat.dart';
import 'package:chat_app/provider/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  Box userBox = LocalStorage.getUserBox();

  late List chatList = userBox.get('chatList', defaultValue: []);

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
      body: ValueListenableBuilder(
        valueListenable: userBox.listenable(keys: ['chatList']),
        builder: (context, box, _) {
          List chatList = box.get('chatList', defaultValue: []);
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            itemCount: chatList.length,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemBuilder: (context, index) {
              var item = chatList[index];
              var newMessage = item['messages'][item['messages'].length - 1];
              int newMessageCount =
                  item['newMessageCount'] > 99 ? 99 : item['newMessageCount'];

              return GestureDetector(
                key: ValueKey(item['friendId']),
                onTap: () async {
                  item['newMessageCount'] = 0;
                  Provider.of<ChatModel>(context, listen: false).setChat(item);
                  Navigator.push(
                    context,
                    animationSlideRoute(Chat(chatItem: item)),
                  );
                  await userBox.put('chatList', chatList);
                },
                child: Dismissible(
                  key: ValueKey(item['friendId']),
                  background: Container(
                    width: 70,
                    color: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('确定删除吗？'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('取消'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('确定'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Avatar(
                          imageUrl: item['avatar'],
                          size: 50,
                          badgeCount: newMessageCount,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    newMessage == null
                                        ? ''
                                        : getDateTime(newMessage['created_at']),
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  newMessage?['type'] == 1
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
                ),
              );
            },
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
