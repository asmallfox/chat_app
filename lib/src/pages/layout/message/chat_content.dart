import 'package:flutter/material.dart';

class ChatContent extends StatefulWidget {
  const ChatContent({
    super.key,
  });

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  @override
  Widget build(BuildContext context) {
    return Text('聊天区域');
  }
}
