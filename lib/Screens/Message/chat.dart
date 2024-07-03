import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/back_icon_button.dart';
import 'package:chat_app/socket/socket_io.dart';
import 'package:chat_app/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class Chat extends StatefulWidget {
  final Map user;
  const Chat({
    super.key,
    required this.user,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late List messageList;

  late TextEditingController _messageInputController;
  late ScrollController _scrollController;

  final currentUserId = Hive.box('settings').get('user', defaultValue: {});
  bool showSendButton = false;

  void sendMessage(String message) async {
    var user = await Hive.box('settings').get('user');
    Map<String, dynamic> message = {
      'userId': user['id'],
      'friendId': 2,
      'message': 'Hello',
      'type': 1,
      'avatar':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'name': '李四',
      'time': '2020-01-01 12:00:00',
      'content': 'Hello'
    };

    SocketIOClient.emit('chat_message', message);

    messageList.add(message);
    jumpTo();
    setState(() {});
  }

  void jumpTo() {
    Future.delayed(
      const Duration(milliseconds: 80),
      () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 80),
          curve: Curves.linear,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    messageList = widget.user['message'];
    _messageInputController = TextEditingController();
    _scrollController = ScrollController();
    jumpTo();
  }

  @override
  void dispose() {
    _messageInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(messageList);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: const BackIconButton(),
        title: Text(widget.user['nickname'] ?? 'unknown'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFD3DAE4), Color(0xFFDCE2EA), Color(0xFFF5F6FA)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                itemCount: messageList.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 15);
                },
                itemBuilder: (context, index) {
                  var item = messageList[index];
                  bool isCurrentUser = item['from'] == currentUserId;
                  return Row(
                    key: ValueKey(index),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    textDirection:
                        isCurrentUser ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Avatar(imageUrl: widget.user['avatar']),
                      Expanded(
                        child: Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Stack(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                padding: const EdgeInsets.all(10),
                                constraints:
                                    const BoxConstraints(minHeight: 45),
                                decoration: BoxDecoration(
                                  color: isCurrentUser
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item['message'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: isCurrentUser
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 15,
                                left: isCurrentUser ? null : 0,
                                right: isCurrentUser ? 0 : null,
                                child: MessageTriangle(
                                  isStart: isCurrentUser,
                                  color: isCurrentUser
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 40)
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomIconButton(
                    icon: Icons.keyboard_voice_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      margin: const EdgeInsets.only(bottom: 4.0),
                      constraints: const BoxConstraints(
                        minHeight: 42,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: TextField(
                        controller: _messageInputController,
                        minLines: 1,
                        maxLines: 8,
                        decoration: null,
                        onChanged: (value) {
                          setState(() {
                            showSendButton = value.isNotEmpty;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomIconButton(
                    icon: Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Visibility(
                    visible: showSendButton,
                    child: FilledButton(
                      onPressed: () {
                        sendMessage(_messageInputController.text);
                        _messageInputController.text = '';
                      },
                      style: FilledButton.styleFrom(
                        // backgroundColor: const Color(0xFF34A047),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.all(0),
                      ),
                      child: const Text(
                        '发送',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTriangle extends StatelessWidget {
  final bool isStart;
  final Color color;
  const MessageTriangle({
    super.key,
    this.isStart = true,
    this.color = Colors.white,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          top: const BorderSide(
            color: Colors.transparent,
            width: 6,
          ),
          bottom: const BorderSide(
            color: Colors.transparent,
            width: 6,
          ),
          start: BorderSide(
            color: isStart ? color : Colors.transparent,
            width: 8,
          ),
          end: BorderSide(
            color: isStart ? Colors.transparent : color,
            width: 8,
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final Function()? onPressed;
  const CustomIconButton({
    super.key,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.size = 24.0,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: color,
        size: size,
      ),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all(backgroundColor ?? Colors.white),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
    );
  }
}
