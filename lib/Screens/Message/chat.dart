import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final List<Map<String, dynamic>> messagaList = [
    {
      'name': '张三',
      'userId': 1,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    },
    {
      'name': '李四',
      'userId': 2,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    },
    {
      'name': '李四',
      'userId': 2,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    },
    {
      'name': '李四',
      'userId': 2,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    },
    {
      'name': '李四',
      'userId': 2,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    },
    {
      'name': '张三',
      'userId': 1,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    },
    {
      'name': '李四',
      'userId': 2,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    },
    {
      'name': '李四',
      'userId': 2,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    },
    {
      'name': '李四',
      'userId': 2,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    },
    {
      'name': '李四',
      'userId': 2,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    },
    {
      'name': '张三',
      'userId': 1,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    },
    {
      'name': '李四',
      'userId': 2,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    },
    {
      'name': '李四',
      'userId': 2,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    },
    {
      'name': '李四',
      'userId': 2,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content': '你好',
      'type': 1
    },
    {
      'name': '李四',
      'userId': 2,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'time': '2020-01-01 12:00:00',
      'content':
          '你好https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpghttps://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'type': 1
    }
  ];

  late TextEditingController _messageInputController;

  final currentUserId = 1;

  @override
  void initState() {
    super.initState();
    _messageInputController = TextEditingController();
  }

  @override
  void dispose() {
    _messageInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                color: Colors.grey[200],
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: messagaList.length,
                  itemBuilder: (context, index) {
                    var item = messagaList[index];
                    return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: item['userId'] == currentUserId
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: item['userId'] != currentUserId
                                  ? BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(item['avatar']),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                    )
                                  : const BoxDecoration(),
                            ),
                            Container(
                              constraints:BoxConstraints(
                                maxWidth: 100
                              ),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: item['userId'] == currentUserId
                                    ? Colors.green[400]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item['content'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Container(
                              width: 44,
                              height: 44,
                              margin: const EdgeInsets.only(left: 12),
                              decoration: item['userId'] == currentUserId
                                  ? BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(item['avatar']),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                    )
                                  : const BoxDecoration(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: const Border(
                  top: BorderSide(
                    width: 0.5,
                    color: Color(0xFFBDBDBD),
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageInputController,
                      minLines: 1,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                        onPressed: () {},
                        child: Text(
                          '发送',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: Color(0xFF34A047),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.all(0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
