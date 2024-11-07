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
              if (_scrollController.offset >= 120) {
              }
            }
          }
        }

        messageList = messages.reversed.toList();
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          reverse: true,
          controller: _scrollController,
          itemCount: messageList.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: 20,
          ),
          itemBuilder: (context, index) {
            final msgItem = messageList[index];
            bool isSelf = _isSelf(msgItem);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: isSelf ? TextDirection.rtl : TextDirection.ltr,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 30,
                  child: friend['avatar'] == null
                      ? Text(
                          friend['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        )
                      : Image.network(
                          isSelf ? box.get('avatar') : friend['avatar']),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    alignment:
                        isSelf ? Alignment.centerRight : Alignment.centerLeft,
                    child: ContentItem(
                      isSelf: isSelf,
                      msgItem: msgItem,
                      friend: widget.item,
                    ),
                  ),
                ),
                const SizedBox(width: 60),
              ],
            );
          },
        );
      },
    );
  }

  bool _isSelf(Map msg) {
    return msg['from'] == UserHive.userInfo['account'];
  }
}
