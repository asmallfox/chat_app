import 'dart:async';

import 'package:chat_app/src/pages/layout/chats/widgets/content_item.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class ConversationContent extends StatefulWidget {
  final Map item;
  const ConversationContent({
    super.key,
    required this.item,
  });

  @override
  State<ConversationContent> createState() => _ConversationContentState();
}

class _ConversationContentState extends State<ConversationContent>
    with SingleTickerProviderStateMixin {
  bool _isSelf(Map msg) {
    return msg['from'] == UserHive.userInfo['account'];
  }

  StreamSubscription? _subscription;

  List messageList = [];

  void _init() {
    print('更新了');
    final friends = UserHive.friends;
    final friend = friends.firstWhere(
      (element) => element['account'] == widget.item['account'],
      orElse: () => ({}),
    );

    final messages = friend['messages'] ?? [];
    // friend['messages'] = [];
    // UserHive.box.put('friends', friends);
    setState(() {
      messageList = messages.reversed.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
    _subscription = UserHive.box.watch(key: 'friends').listen((_) => _init());
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.topCenter,
        child: ListView.separated(
          reverse: true,
          shrinkWrap: true,
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
  }
}
