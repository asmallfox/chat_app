import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Map<String, dynamic>> messagaList = [
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
      'content': '你好啊，我是李四！',
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
  late ScrollController _scrollController;

  final currentUserId = 1;

  void sendMessage(String message) {
    setState(() {
      messagaList.add({
        'name': '李四',
        'userId': currentUserId,
        'avatar':
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
        'time': '2020-01-01 12:00:00',
        'content': message,
        'type': 1
      });
    });
    Future.delayed(
      const Duration(milliseconds: 80),
      () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _messageInputController = TextEditingController();
    _scrollController = ScrollController();
    // Future.delayed(
    //   const Duration(milliseconds: 80),
    //   () {
    //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    //   },
    // );
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
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                itemCount: messagaList.length,
                itemBuilder: (context, index) {
                  var item = messagaList[index];
                  return Row(
                    key: ValueKey(index),
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          image: DecorationImage(
                            image: NetworkImage(
                              item['avatar'],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: item['userId'] == currentUserId
                              ? Colors.green[400]
                              : Colors.white,
                        ),
                        child: Text(
                          item['content'],
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      // const SizedBox(
                      //   width: 60,
                      // )
                    ],
                  );
                },
              ),
            ),
          ),
          // Expanded(
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 15),
          //     color: Colors.grey[200],
          //     child: ListView.builder(
          //       physics: const BouncingScrollPhysics(),
          //       controller: _scrollController,
          //       itemCount: messagaList.length,
          //       itemBuilder: (context, index) {
          //         var item = messagaList[index];
          //         return GestureDetector(
          //           key: ValueKey(index),
          //           child: Padding(
          //             padding: const EdgeInsets.only(bottom: 15, top: 15),
          //             child: Row(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               mainAxisAlignment: item['userId'] == currentUserId
          //                   ? MainAxisAlignment.end
          //                   : MainAxisAlignment.start,
          //               children: [
          //                 Container(
          //                   width: 44,
          //                   height: 44,
          //                   margin: const EdgeInsets.only(right: 12),
          //                   decoration: item['userId'] != currentUserId
          //                       ? BoxDecoration(
          //                           image: DecorationImage(
          //                             image: NetworkImage(item['avatar']),
          //                             fit: BoxFit.cover,
          //                           ),
          //                           borderRadius: const BorderRadius.all(
          //                             Radius.circular(6),
          //                           ),
          //                         )
          //                       : null,
          //                 ),
          //                 Expanded(
          //                   child: Align(
          //                     alignment: item['userId'] == currentUserId
          //                         ? Alignment.centerRight
          //                         : Alignment.centerLeft,
          //                     child: Container(
          //                       padding: const EdgeInsets.all(10),
          //                       decoration: BoxDecoration(
          //                         color: item['userId'] == currentUserId
          //                             ? Colors.green[400]
          //                             : Colors.white,
          //                         borderRadius: BorderRadius.circular(4),
          //                       ),
          //                       child: Text(
          //                         item['content'],
          //                         style: const TextStyle(
          //                           color: Colors.black,
          //                           fontSize: 18,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 Container(
          //                   width: 44,
          //                   height: 44,
          //                   margin: const EdgeInsets.only(left: 12),
          //                   decoration: item['userId'] == currentUserId
          //                       ? BoxDecoration(
          //                           image: DecorationImage(
          //                             image: NetworkImage(item['avatar']),
          //                             fit: BoxFit.cover,
          //                           ),
          //                           borderRadius: const BorderRadius.all(
          //                             Radius.circular(6),
          //                           ),
          //                         )
          //                       : null,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
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
                FilledButton(
                  onPressed: () {
                    sendMessage(_messageInputController.text);
                    _messageInputController.text = '';
                  },
                  child: Text(
                    '发送',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF34A047),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.all(0),
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
