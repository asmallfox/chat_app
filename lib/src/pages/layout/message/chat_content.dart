import 'package:chat_app/src/utils/hive_util.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class ChatContent extends StatefulWidget {
  final Map item;
  const ChatContent({
    super.key,
    required this.item,
  });

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent>
    with SingleTickerProviderStateMixin {
  List<Map> messageList = [];

  final ScrollController _scrollController = ScrollController();

  Future<void> _initMessages() async {
    final user = UserHive.getUserInfo();
    messageList = widget.item['messages'] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _initMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: messageList.length,
      itemBuilder: (context, index) {
        final msgItem = messageList[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: msgItem['avatar'] == null
                ? Text(
                    msgItem['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  )
                : Image.network(msgItem['avatar']),
          ),
          title: const Text('Hello, World!'),
          subtitle: Text(msgItem['content']),
        );
      },
    );
  }
}
