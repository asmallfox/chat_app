import 'dart:async';
import 'dart:io';

import 'package:chat_app/Helpers/find_data.dart';
import 'package:chat_app/Helpers/show_tip_message.dart';
import 'package:chat_app/Screens/Message/chat_audio_page.dart';
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
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  final Map<dynamic, dynamic> chatItem;

  const Chat({
    super.key,
    required this.chatItem,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late List messageList;
  late List friends;
  late List chatList;
  late final ScrollController _scrollController = ScrollController();

  final Map userInfo = LocalStorage.getUserInfo();
  final Box userBox = LocalStorage.getUserBox();
  final currentUser = Hive.box('settings').get('user', defaultValue: {});

  final GlobalKey audioCloseKey = GlobalKey();

  bool showSendButton = false;
  bool showAudioPanel = false;
  bool isOverlyClose = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 初始化
  void _initialize() {
    messageList = widget.chatItem['messages'] ?? [];
    friends = userBox.get('friends', defaultValue: []);
    chatList = userBox.get('chatList', defaultValue: []);
  }

  void _handleAudioSend(String path) async {
    setState(() {
      showAudioPanel = false;
    });
    isOverlyClose = false;

    try {
      // 获取应用程序的本地存储目录
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      // 生成一个唯一的文件名
      String filePath =
          '$appDocPath/local-${DateTime.now().millisecondsSinceEpoch}.aac';

      File file = File(filePath);

      File audioFile = File(path);

      await file.writeAsBytes(audioFile.readAsBytesSync());

      sendMessage({
        'type': 3,
        'content': filePath,
        'file': audioFile.readAsBytesSync(),
      });
      print('语音数据已保存到: $filePath');
    } catch (error) {
      print('语音缓存失败: $error');
    }
  }

  Future<void> sendMessage(Map params) async {
    Box userBox = LocalStorage.getUserBox();

    List friends = await userBox.get('friends', defaultValue: []);
    List chatList = await userBox.get('chatList', defaultValue: []);
    List chatMessage = await userBox.get('chatMessage', defaultValue: []);

    Map data = {
      'to': widget.chatItem['friendId'],
      'from': userInfo['id'],
      'message': params['content'] ?? params['message'],
      'file': params['file'],
      'type': params['type'],
    };

    Map msg = {
      ...data,
      'status': MessageStatus.sending,
      'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };

    if (msg.containsKey('file')) {
      msg.remove('file');
    }

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

    Future<void> saveData() async {
      await userBox.put('chatList', chatList);
      await userBox.put('friends', friends);
      await userBox.put('chatMessage', chatMessage);
    }

    final timer = Timer(const Duration(seconds: 15), () async {
      messageList.remove(msg);
      chatMessage.remove(msg);

      final data = {
        ...msg,
        'status': MessageStatus.fail,
      };

      if (data.containsKey('file')) {
        data.remove('file');
      }

      messageList.add(data);
      chatMessage.add(data);

      currentFriend['messages'] = messageList;
      await saveData();
    });

    SocketIOClient.emitWithAck('chat_message', data, ack: (row) async {
      timer.cancel();

      final data = {
        ...row,
        'message': row['type'] == 1 ? row['message'] : msg['message'],
        'status': MessageStatus.success,
      };

      messageList.remove(msg);
      chatMessage.remove(msg);

      messageList.add(data);
      chatMessage.add(data);

      currentFriend['messages'] = messageList;
      await saveData();
    });

    await saveData();
  }

  void deleteChatRecord(int index) async {
    setState(() {
      messageList.removeAt(index);
    });

    Box userBox = LocalStorage.getUserBox();

    List friends = await userBox.get('friends', defaultValue: []);
    List chatList = await userBox.get('chatList', defaultValue: []);

    Map currentFriend = listFind(
      friends,
      (item) => item['friendId'] == widget.chatItem['friendId'],
    );

    Map? currentChat = listFind(
      chatList,
      (item) => item['friendId'] == widget.chatItem['friendId'],
    );

    currentFriend['messages'] = messageList;

    if (currentChat != null) {
      currentChat['messages'] = messageList;
    }

    await Hive.box('chat').put('friends', friends);
    await Hive.box('chat').put('chatList', chatList);
  }

  Future<void> removeChatRecord() async {
    final item = {...widget.chatItem, 'messages': []};

    Box userBox = LocalStorage.getUserBox();

    List friends = await userBox.get('friends', defaultValue: []);
    List chatList = await userBox.get('chatList', defaultValue: []);
    List chatMessage = await userBox.get('chatMessage', defaultValue: []);

    final friend = findDataItem(friends, 'friendId', item['friendId']);
    final chatItemData = findDataItem(chatList, 'friendId', item['friendId']);

    messageList = [];

    if (friend != null) {
      friend['messages'] = messageList;
    }
    if (chatItemData != null) {
      chatItemData['messages'] = messageList;
    }

    chatMessage.removeWhere((item) =>
        (item['from'] == userInfo['id'] && item['to'] == item['friendId']) ||
        (item['to'] == userInfo['id'] && item['from'] == item['friendId']));

    userBox.put('friends', friends);
    userBox.put('chatList', chatList);

    setState(() {});
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
                  Provider.of<ChatModelProvider>(context, listen: false)
                      .clearChat();
                },
              ),
              title: Text(widget.chatItem['nickname'] ?? 'unknown'),
              actions: [
                IconButton(
                  onPressed: () async {
                    print('语音');

                    final chatModel = context.read<ChatModelProvider>();

                    if (chatModel.communicate == null ||
                        chatModel.communicate?['friendId'] ==
                            widget.chatItem['friendId']) {
                      if (chatModel.communicate == null) {
                        chatModel.sendCallAudio(widget.chatItem);
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatAudioPage(),
                        ),
                      );
                    } else {
                      showTipMessage(context, '正在通话中..');
                    }
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
                IconButton(
                  onPressed: () {
                    print('更多');
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('是否删除全部聊天记录？'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await removeChatRecord();

                                  if (!context.mounted) return;

                                  Navigator.of(context).pop();
                                },
                                child: const Text('确定'),
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.more_vert_rounded),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            body: ValueListenableBuilder(
              valueListenable: userBox.listenable(keys: ['chatList']),
              builder: (context, box, _) {
                final list = messageList.reversed.toList();

                return Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: ListView.separated(
                            reverse: true,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(20),
                            physics: const BouncingScrollPhysics(),
                            controller: _scrollController,
                            itemCount: list.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 20),
                            itemBuilder: (context, index) {
                              final item = list[index];
                              bool isCurrentUser =
                                  item['from'] == userInfo['id'];
                              String avatar = isCurrentUser
                                  ? userInfo['avatar']
                                  : widget.chatItem['avatar'];

                              return Row(
                                key: ValueKey(index),
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    child: Container(
                                      alignment: isCurrentUser
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: ChatMessageItem(item: item),
                                    ),
                                  ),
                                  const SizedBox(width: 36)
                                ],
                              );
                            },
                          ),
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
                        endAudio: _handleAudioSend,
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
