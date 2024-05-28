import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Map<String, dynamic>> messageList = [
    // {
    //   'name': '李四',
    //   'userId': 2,
    //   'avatar':
    //       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    //   'time': '2020-01-01 12:00:00',
    //   'content': '你好',
    //   'type': 1
    // },
    // {
    //   'name': '张三',
    //   'userId': 1,
    //   'avatar':
    //       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    //   'time': '2020-01-01 12:00:00',
    //   'content': '你好',
    //   'type': 1
    // },
    // {
    //   'name': '李四',
    //   'userId': 2,
    //   'avatar':
    //       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    //   'time': '2020-01-01 12:00:00',
    //   'content': '你好',
    //   'type': 1
    // },
    // {
    //   'name': '李四',
    //   'userId': 2,
    //   'avatar':
    //       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    //   'time': '2020-01-01 12:00:00',
    //   'content': '你好',
    //   'type': 1
    // },
    // {
    //   'name': '李四',
    //   'userId': 2,
    //   'avatar':
    //       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    //   'time': '2020-01-01 12:00:00',
    //   'content': '你好',
    //   'type': 1
    // },
    // {
    //   'name': '李四',
    //   'userId': 2,
    //   'avatar':
    //       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    //   'time': '2020-01-01 12:00:00',
    //   'content': '你好',
    //   'type': 1
    // },
    // {
    //   'name': '李四',
    //   'userId': 2,
    //   'avatar':
    //       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    //   'time': '2020-01-01 12:00:00',
    //   'content': '你好',
    //   'type': 1
    // },
    // {
    //   'name': '李四',
    //   'userId': 2,
    //   'avatar':
    //       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    //   'time': '2020-01-01 12:00:00',
    //   'content': '你好啊，我是李四！',
    //   'type': 1
    // },
    // {
    //   'name': '李四',
    //   'userId': 2,
    //   'avatar':
    //       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    //   'time': '2020-01-01 12:00:00',
    //   'content':
    //       '你好https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpghttps://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    //   'type': 1
    // }
  ];

  late TextEditingController _messageInputController;
  late ScrollController _scrollController;

  final currentUserId = 1;

  void sendMessage(String message) {
    setState(() {
      messageList.add({
        'name': '李四',
        'userId': currentUserId,
        'avatar':
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
        'time': '2020-01-01 12:00:00',
        'content': message,
        'type': 1
      });
    });
    jumpTo();
  }

  void jumpTo() {
    Future.delayed(
      const Duration(milliseconds: 80),
      () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 80),
          curve: Curves.linear,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _messageInputController = TextEditingController();
    _scrollController = ScrollController();
    jumpTo();
  }

  @override
  void dispose() {
    _messageInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                itemCount: messageList.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 15);
                },
                itemBuilder: (context, index) {
                  var item = messageList[index];
                  bool isCurrentUser = item['userId'] == currentUserId;
                  return Row(
                    key: ValueKey(index),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    textDirection:
                        isCurrentUser ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              item['avatar'],
                            ),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Stack(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                padding: const EdgeInsets.all(10),
                                constraints:
                                    const BoxConstraints(minHeight: 45),
                                decoration: BoxDecoration(
                                  color: isCurrentUser
                                      ? Colors.green[400]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item['content'],
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              Positioned(
                                top: 15,
                                left: isCurrentUser ? null : 0,
                                right: isCurrentUser ? 0 : null,
                                child: MessageTriangle(
                                  isStart: isCurrentUser,
                                  color: isCurrentUser
                                      ? Colors.green
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 40)
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            constraints: const BoxConstraints(minHeight: 50),
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.pink[100],
                    child: TextField(
                      controller: _messageInputController,
                      minLines: 1,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        // contentPadding: EdgeInsets.symmetric(horizontal: 0)
                      ),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () {
                    sendMessage(_messageInputController.text);
                    _messageInputController.text = '';
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF34A047),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.all(0),
                  ),
                  child: const Text(
                    '发送',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTriangle extends StatelessWidget {
  final bool isStart;
  final Color color;
  const MessageTriangle({
    super.key,
    this.isStart = true,
    this.color = Colors.white,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          top: const BorderSide(
            color: Colors.transparent,
            width: 6,
          ),
          bottom: const BorderSide(
            color: Colors.transparent,
            width: 6,
          ),
          start: BorderSide(
            color: isStart ? color : Colors.transparent,
            width: 8,
          ),
          end: BorderSide(
            color: isStart ? Colors.transparent : color,
            width: 8,
          ),
        ),
      ),
    );
  }
}
