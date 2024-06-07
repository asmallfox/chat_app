import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/search_user_page.dart';
import 'package:chat_app/Helpers/animation_slide_route.dart';
import 'package:chat_app/Screens/Message/chat.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  final List<Map<String, dynamic>> userList = [
    {
      'username': 1,
      'nickname': '张三',
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    }
  ];
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
        itemCount: userList.length,
        itemBuilder: (context, index) {
          var item = userList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, animationSlideRoute(Chat(item: item)));
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
                              '16:00',
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            item['type'] == 1
                                ? Text(
                                    '[type]',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  )
                                : const SizedBox(),
                            item['type'] == 1
                                ? Expanded(
                                    child: Text(
                                      item['content'],
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                      ),
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
