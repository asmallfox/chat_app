import 'dart:async';
import 'dart:io';

import 'package:chat_app/Screens/Message/chat_message_item.dart';
import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/back_icon_button.dart';
import 'package:chat_app/CustomWidget/custom_model.dart';
import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/Helpers/system_utils.dart';
import 'package:chat_app/Helpers/util.dart';
import 'package:chat_app/Screens/Message/chat_tab_panel.dart';
import 'package:chat_app/constants/status.dart';
import 'package:chat_app/provider/model/chat_model.dart';
import 'package:chat_app/socket/socket_io.dart';
import 'package:chat_app/theme/colors.dart';
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
  late ScrollController _scrollController;
  late StreamSubscription _chatListWatch;

  final Map userInfo = LocalStorage.getUserInfo();
  final Box userBox = LocalStorage.getUserBox();
  final currentUser = Hive.box('settings').get('user', defaultValue: {});

  final GlobalKey audioCloseKey = GlobalKey();

  bool showSendButton = false;
  bool showAudioPanel = false;
  bool isOverlyClose = false;

  Future<void> sendMessage(Map params) async {
    Box userBox = LocalStorage.getUserBox();

    List friends = await userBox.get('friends', defaultValue: []);
    List chatList = await userBox.get('chatList', defaultValue: []);
    List chatMessage = await userBox.get('chatMessage', defaultValue: []);

    Map data = {
      'to': widget.chatItem['friendId'],
      'from': userInfo['id'],
      'message': params['content'],
      'file': params['file'],
      'type': params['type'],
    };

    print('xxxxxxxxxxxxxxxx $data');

    Map msg = {
      ...data,
      // 'status': MessageStatus['sending'],
      'status': MessageStatus.sending,
      'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };

    messageList.add(msg);
    chatMessage.add(msg);

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
      // await userBox.put('chatList', chatList);
      // await userBox.put('friends', friends);
      // await userBox.put('chatMessage', chatMessage);
    }

    final timer = Timer(const Duration(seconds: 15), () async {
      messageList.remove(msg);
      chatMessage.remove(msg);

      final data = {
        ...msg,
        'status': MessageStatus.fail,
      };

      messageList.add(data);
      chatMessage.add(data);

      currentFriend['messages'] = messageList;
      await saveData();
      setState(() {});
    });

    SocketIOClient.emitWithAck('chat_message', data, ack: (row) async {
      timer.cancel();
      messageList.remove(msg);
      chatMessage.remove(msg);

      final data = {
        ...row,
        'status': MessageStatus.success,
      };

      messageList.add(data);
      chatMessage.add(data);

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
    _scrollController.dispose();
    _chatListWatch.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomModel(
      children: [
        GestureDetector(
          onTap: () {
            SystemUtils.hideSoftKeyBoard(context);
            chatTabPanelKey.currentState?.onHiddenPanel();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: BackIconButton(
                backFn: () {
                  Provider.of<ChatModel>(context, listen: false).removeChat();
                },
              ),
              title: Text(widget.chatItem['nickname'] ?? 'unknown'),
              actions: [
                IconButton(
                  onPressed: () {
                    // ...
                    print('语音');
                  },
                  icon: const Icon(Icons.phone),
                  color: Theme.of(context).colorScheme.primary,
                ),
                IconButton(
                  onPressed: () {
                    // ...
                    print('视频');
                  },
                  icon: const Icon(Icons.videocam_sharp),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            body: ValueListenableBuilder(
              valueListenable: userBox.listenable(keys: ['chatList']),
              builder: (context, box, _) {
                return Container(
                  color: Colors.white,
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

                            int menuItemIndex = 1;

                            return Column(
                              key: ValueKey(index),
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  textDirection: isCurrentUser
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  children: [
                                    Avatar(
                                      imageUrl: avatar,
                                      size: 42,
                                      rounded: true,
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: isCurrentUser
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Visibility(
                                              visible: item['status'] == null ||
                                                  item['status'] !=
                                                      MessageStatus.success,
                                              child: item['status'] ==
                                                      MessageStatus.sending
                                                  ? const SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 3,
                                                      ),
                                                    )
                                                  : GestureDetector(
                                                      child: const Icon(
                                                        Icons.error_outline,
                                                        color: AppColors
                                                            .errorColor,
                                                      ),
                                                    ),
                                            ),
                                            PopupMenuButton(
                                              initialValue: menuItemIndex,
                                              onCanceled: () async {
                                                messageList.removeAt(index);

                                                Box userBox =
                                                    LocalStorage.getUserBox();

                                                List friends = await userBox
                                                    .get('friends',
                                                        defaultValue: []);
                                                List chatList = await userBox
                                                    .get('chatList',
                                                        defaultValue: []);
                                                // List chatMessage = await userBox.get('chatMessage', defaultValue: []);

                                                Map currentFriend = listFind(
                                                  friends,
                                                  (item) =>
                                                      item['friendId'] ==
                                                      widget
                                                          .chatItem['friendId'],
                                                );

                                                Map? currentChat = listFind(
                                                  chatList,
                                                  (item) =>
                                                      item['friendId'] ==
                                                      widget
                                                          .chatItem['friendId'],
                                                );

                                                currentFriend['messages'] =
                                                    messageList;

                                                if (currentChat != null) {
                                                  currentChat['messages'] =
                                                      messageList;
                                                }
                                                await Hive.box('chat')
                                                    .put('friends', friends);
                                                await Hive.box('chat')
                                                    .put('chatList', chatList);

                                                setState(() {});
                                              },
                                              itemBuilder: (context) {
                                                return <PopupMenuEntry>[
                                                  const PopupMenuItem(
                                                    child: Text('删除'),
                                                  ),
                                                ];
                                              },
                                              child: ChatMessageItem(
                                                item: item,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 36)
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      ChatTabPanel(
                        key: chatTabPanelKey,
                        audioCloseKey: audioCloseKey,
                        onSend: (Map params) {
                          sendMessage(params);
                        },
                        startAudio: () {
                          setState(() {
                            showAudioPanel = true;
                          });
                        },
                        endAudio: (String path) {
                          setState(() {
                            showAudioPanel = false;
                          });
                          isOverlyClose = false;
                          sendMessage({
                            'type': 3,
                            'content': path,
                            'file': File(path),
                          });
                        },
                        closeBlur: () {
                          setState(() {
                            isOverlyClose = false;
                          });
                        },
                        closeFocus: () {
                          setState(() {
                            isOverlyClose = true;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Visibility(
          visible: showAudioPanel,
          child: Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showAudioPanel = !showAudioPanel;
                });
              },
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    height: showAudioPanel ? 300 : 0,
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          key: audioCloseKey,
                          padding: EdgeInsets.all(isOverlyClose ? 10 : 8.0),
                          decoration: BoxDecoration(
                            color: isOverlyClose
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                        ),
                        // Column(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Icon(
                        //       Icons.multitrack_audio_rounded,
                        //       size: 48,
                        //       color: Theme.of(context).colorScheme.secondary,
                        //     ),
                        //     const SizedBox(
                        //       height: 10,
                        //     ),
                        //     Text(
                        //       '松开发送',
                        //       style: TextStyle(
                        //         color: Theme.of(context).colorScheme.secondary,
                        //         fontSize: 14,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            // color: isOverlyClose
                            //     ? Theme.of(context).colorScheme.primary
                            //     : Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.question_mark_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
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
