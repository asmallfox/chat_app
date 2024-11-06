import 'package:chat_app/src/theme/colors.dart';
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

  final ScrollController _scrollController = ScrollController();

  Future<void> _initMessages() async {
    // final userBox = UserHive.getUserInfo();
    // final user = UserHive.getUserInfo();
    // final friend = user['friends'].findWhere((element) => element['account'] == widget.item['account']);
    // messageList = friend['messages'] ?? [];
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
    return ValueListenableBuilder(
      valueListenable: userBox.listenable(keys: ['friends']),
      builder: (context, box, child) {
        final friend = box.get('friends', defaultValue: []).firstWhere(
                (element) => element['account'] == widget.item['account']) ??
            {};
        messageList = (friend['messages'] ?? []);

        return ListView.builder(
          controller: _scrollController,
          itemCount: messageList.length,
          itemBuilder: (context, index) {
            final msgItem = messageList[index];
            bool isSelf = _isSelf(msgItem);
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
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
              title: Container(
                color: isSelf ? AppColors.primary : Colors.red,
                child: Text(msgItem['content']),
              ),
            );
          },
        );
      },
    );
  }

  bool _isSelf(Map msg) {
    return msg['account'] == UserHive.userInfo['account'];
  }
}
