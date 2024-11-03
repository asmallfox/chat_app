import 'package:flutter/material.dart';

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
  List messageList = [];

  final ScrollController _scrollController = ScrollController();

  Future<void> _initMessages() async {
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
    print(widget.item);
    return ListView.builder(
      controller: _scrollController,
      itemCount: messageList.length,
      itemBuilder: (context, index) {
        final msgItem = messageList[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text("A ${index}"),
          ),
          title: const Text('Hello, World!'),
          subtitle: Text(msgItem['message']),
        );
      },
    );
  }
}
