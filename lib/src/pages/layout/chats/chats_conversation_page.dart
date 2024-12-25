import 'package:chat_app/src/pages/layout/chats/chats_audio.page.dart';
import 'package:chat_app/src/pages/layout/chats/chats_video_page.dart';
import 'package:chat_app/src/pages/layout/chats/widgets/conversation_content.dart';
import 'package:chat_app/src/pages/layout/chats/widgets/conversation_panel.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/utils/message_util.dart';
import 'package:chat_app/src/widgets/back_icon_button.dart';
import 'package:chat_app/src/widgets/key_board_container.dart';
import 'package:flutter/material.dart';

class ChatsConversationPage extends StatefulWidget {
  final Map item;
  const ChatsConversationPage({
    super.key,
    required this.item,
  });

  @override
  State<ChatsConversationPage> createState() => _ChatsConversationPage();
}

class _ChatsConversationPage extends State<ChatsConversationPage> {
  @override
  Widget build(BuildContext context) {
    return KeyboardContainer(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          leading: const BackIconButton(),
          title: Text(widget.item['name']),
          actions: [
            IconButton(
              onPressed: () async {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        ChatsAudioPage(friend: widget.item),
                  ),
                );
              },
              icon: const Icon(Icons.phone),
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        ChatsVideoPage(friend: widget.item),
                  ),
                );
              },
              icon: const Icon(Icons.videocam_sharp),
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert_rounded),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        body: Column(
          children: [
            ConversationContent(item: widget.item),
            ConversationPanel(
              onSend: _onSendMessage,
            )
          ],
        ),
      ),
    );
  }

   void _onSendMessage(Map data) {
    MessageUtil.sendMessage(
      type: data['type'],
      content: data['content'],
      from: UserHive.userInfo['account'],
      to: widget.item['account'],
      duration: data['duration'],
    );
  }
}
