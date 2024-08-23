import 'dart:math';

import 'package:chat_app/src/utils/get_date_time.dart';
import 'package:flutter/material.dart';

class MessageList extends StatefulWidget {
  const MessageList({
    super.key,
  });

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  List chatList = List.generate(
    100,
    (index) {
      final random = Random();
      return {
        'name': (index + 1).toString(),
        'date': getDateTime(DateTime.now().microsecond),
        'color': Color.fromARGB(
          255,
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
        )
      };
    },
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 15, bottom: 15),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: chatList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              alignment: Alignment.center,
              width: 52,
              height: 52,
              color: chatList[index]['color'],
              child: Text(
                chatList[index]['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  chatList[index]['name'],
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(chatList[index]['date'])
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('[新消息] ' + chatList[index]['name']),
                Badge.count(
                  count: 99,
                  backgroundColor: const Color(
                    0xFFf5a13c,
                  ),
                  isLabelVisible: index % 10 == 2,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
