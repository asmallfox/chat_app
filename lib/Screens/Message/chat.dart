import 'dart:async';

import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/back_icon_button.dart';
import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/Helpers/util.dart';
import 'package:chat_app/constants/status.dart';
import 'package:chat_app/provider/model/chat_model.dart';
import 'package:chat_app/socket/socket_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  final Map chatItem;
  const Chat({
    super.key,
    required this.chatItem,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late List messageList;
  late TextEditingController _messageInputController;
  late ScrollController _scrollController;

  final Map userInfo = LocalStorage.getUserInfo();
  Box userBox = LocalStorage.getUserBox();

  final currentUser = Hive.box('settings').get('user', defaultValue: {});

  var chatMessageValueListenable =
      Hive.box('chat').listenable(keys: ['chatMessage']);

  bool showSendButton = false;
  late StreamSubscription _chatListWatch;

  Future<void> sendMessage() async {
    Box userBox = LocalStorage.getUserBox();

    List friends = await userBox.get('friends', defaultValue: []);
    List chatList = await userBox.get('chatList', defaultValue: []);
    List chatMessage = await userBox.get('chatMessage', defaultValue: []);

    Map data = {
      'to': widget.chatItem['friendId'],
      'from': userInfo['id'],
      'message': _messageInputController.text,
      'type': messageType['text']?['value']
    };

    Map msg = {
      ...data,
      'status': messageStatus['sending'],
      'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };

    messageList.add(msg);
    chatMessage.add(msg);

    _messageInputController.text = '';

    Map currentFriend = listFind(
      friends,
      (item) => item['friendId'] == widget.chatItem['friendId'],
    );

    Map? currentChat = listFind(
      chatList,
      (item) => item['friendId'] == widget.chatItem['friendId'],
    );

    currentFriend['messages'] = messageList;

    if (currentChat == null) {
      chatList.add(currentFriend);
    } else {
      currentChat['messages'] = messageList;
    }

    jumpTo(_scrollController);

    Future<void> saveData() async {
      await userBox.put('chatList', chatList);
      await userBox.put('friends', friends);
      await userBox.put('chatMessage', chatMessage);
    }

    SocketIOClient.emitWithAck('chat_message', data, ack: (row) async {
      messageList.remove(msg);
      messageList.add(row);
      chatMessage.remove(msg);
      chatMessage.add(row);

      currentFriend['messages'] = messageList;
      await saveData();
      setState(() {});
    });
    await saveData();
  }

  @override
  void initState() {
    super.initState();
    messageList = widget.chatItem['messages'] ?? [];
    _messageInputController = TextEditingController();
    _scrollController = ScrollController();
    _chatListWatch = userBox.watch(key: 'chatList').listen((event) {
      setState(() {
        jumpTo(_scrollController);
      });
    });
    jumpTo(_scrollController);
  }

  @override
  void dispose() {
    _messageInputController.dispose();
    _scrollController.dispose();
    _chatListWatch.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: BackIconButton(
          backFn: () {
            Provider.of<ChatModel>(context, listen: false).removeChat();
          },
        ),
        title: Text(widget.chatItem['nickname'] ?? 'unknown'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: userBox.listenable(keys: ['chatList']),
        builder: (context, box, _) {
          return Container(
            decoration: const BoxDecoration(
              // color: Color(0xFFf4f5f9)
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFD3DAE4),
                  Color(0xFFDCE2EA),
                  Color(0xFFF5F6FA)
                ],
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
                      bool isCurrentUser = item['from'] == userInfo['id'];
                      String avatar = isCurrentUser
                          ? userInfo['avatar']
                          : widget.chatItem['avatar'];

                      return Row(
                        key: ValueKey(index),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        textDirection: isCurrentUser
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        children: [
                          Avatar(
                            imageUrl: avatar,
                            size: 42,
                          ),
                          Expanded(
                            child: Align(
                              alignment: isCurrentUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 10,
                                    ),
                                    constraints: const BoxConstraints(
                                      minHeight: 40,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isCurrentUser
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
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
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 42)
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
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
                          onPressed: () async {
                            await sendMessage();
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
          );
        },
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

void jumpTo(ScrollController controller) {
  Future.delayed(
    const Duration(milliseconds: 0),
    () {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 80),
        curve: Curves.linear,
      );
    },
  );
}


// void sendMessage() async {
//   Box chatBox = Hive.box('chat');
//   List chatList = await chatBox.get('chatList', defaultValue: []);
//   List friendList = await chatBox.get('friendList', defaultValue: []);
//   List chatMessage = await chatBox.get('chatMessage', defaultValue: []);

//   var data = {
//     'to': widget.chatItem['friendId'],
//     'from': currentUser['id'],
//     'message': _messageInputController.text,
//     'type': messageType['text']?['value']
//   };

//   Map msg = {
//     ...data,
//     'status': messageStatus['sending'],
//     'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
//   };

//   messageList.add(msg);
//   chatMessage.add(msg);

//   _messageInputController.text = '';

//   Map currentFriend = listFind(
//     friendList,
//     (item) => item['friendId'] == widget.chatItem['friendId'],
//   );

//   Map? currentChat = listFind(
//     chatList,
//     (item) => item['friendId'] == widget.chatItem['friendId'],
//   );

//   currentFriend['messages'] = messageList;

//   if (currentChat == null) {
//     chatList.add(currentFriend);
//   } else {
//     currentChat['messages'] = messageList;
//   }

//   jumpTo();

//   SocketIOClient.emitWithAck('chat_message', data, ack: (row) async {
//     messageList.remove(msg);
//     messageList.add(row);
//     currentFriend['messages'] = messageList;

//     chatMessage.remove(msg);
//     chatMessage.add(row);

//     jumpTo();

//     await chatBox.put('chatList', chatList);
//     await chatBox.put('friendList', friendList);
//     await chatBox.put('chatMessage', chatMessage);
//   });

//   await chatBox.put('chatList', chatList);
//   await chatBox.put('friendList', friendList);
//   await chatBox.put('chatMessage', chatMessage);
// }
