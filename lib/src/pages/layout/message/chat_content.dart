import 'package:chat_app/src/pages/layout/message/widgets/content_item.dart';
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
  List messageList = [];
  final Box userBox = UserHive.box;

  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ChatContent oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: userBox.listenable(keys: ['friends']),
      builder: (context, box, child) {
        
        final friend = box.get('friends', defaultValue: []).firstWhere(
                (element) => element['account'] == widget.item['account']) ??
            {};

        final messages = friend['messages'] ?? [];
        if (messages.isNotEmpty && messageList.isNotEmpty) {
          if (messageList.length > messages.length) {
          } else {
            if (_isSelf(messages.last)) {
              Future.delayed(Duration.zero, () => _scrollController.jumpTo(0));
            } else {
              if (_scrollController.offset >= 120) {}
            }
          }
        }

        messageList = messages.reversed.toList();

        return Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: ListView.separated(
              reverse: true,
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: messageList.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final msgItem = messageList[index];
                bool isSelf = _isSelf(msgItem);
                return ContentItem(
                  isSelf: isSelf,
                  msgItem: msgItem,
                  friend: widget.item,
                );
              },
            ),
          ),
        );
      },
    );
  }

  bool _isSelf(Map msg) {
    return msg['from'] == UserHive.userInfo['account'];
  }
}
