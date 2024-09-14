import 'package:chat_app/CustomWidget/back_icon_button.dart';
import 'package:chat_app/src/pages/layout/message/chat_content.dart';
import 'package:chat_app/src/pages/layout/message/chat_panel.dart';
import 'package:chat_app/src/widgets/key_board_container.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return KeyboardContainer(
      child: Scaffold(
        appBar: AppBar(
          leading: BackIconButton(
            backFn: () {},
          ),
          title: const Text('谁在聊天...'),
          actions: [
            IconButton(
              onPressed: () async {
                print('语音');
              },
              icon: const Icon(Icons.phone),
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              onPressed: () {
                print('视频');
              },
              icon: const Icon(Icons.videocam_sharp),
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              onPressed: () {
                print('更多');
              },
              icon: const Icon(Icons.more_vert_rounded),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        body: const Column(
          children: [
            Expanded(
              child: ChatContent(),
            ),
            ChatPanel(),
          ],
        ),
      ),
    );
  }
}
