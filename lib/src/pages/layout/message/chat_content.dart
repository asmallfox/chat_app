import 'package:flutter/material.dart';

class ChatContent extends StatefulWidget {
  const ChatContent({
    super.key,
  });

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
      itemCount: 20,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text("A ${index}"),
          ),
          title: const Text('Hello, World!'),
          subtitle: const Text('This is a sample message.'),
        );
      },
    );
  }
}
