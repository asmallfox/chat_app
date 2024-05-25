import 'package:chat_app/Screens/Message/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  final List<Map<String, dynamic>> userList = [
    {
      'name': '张三',
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    }
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          var item = userList[index];
          return GestureDetector(
            onTap: () {
              print('点击了');
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, _, __) {
                    return Chat();
                  },
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      image: DecorationImage(
                        image: NetworkImage(item['avatar']),
                        fit: BoxFit.cover,
                      ),
                    ),
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
                                item['name'],
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
        });
  }
}
