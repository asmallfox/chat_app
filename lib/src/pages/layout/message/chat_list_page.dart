import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/utils/get_date_time.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/utils/message_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import './chat_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({
    super.key,
  });

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
  Offset menuAnchorPosition = const Offset(0, 0);

  // List chatList = List.generate(
  //   20,
  //   (index) {
  //     final random = Random();
  //     return {
  //       'name': (index + 1).toString(),
  //       'date': getDateTime(DateTime.now().microsecond),
  //       'color': Color.fromARGB(
  //         255,
  //         random.nextInt(256),
  //         random.nextInt(256),
  //         random.nextInt(256),
  //       )
  //     };
  //   },
  // );

  // List chatList =[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: UserHive.box.listenable(keys: ['friends']),
      builder: (context, box, child) {
        List chatList = box.get('chatList', defaultValue: []);
        return Scaffold(
          appBar: AppBar(
            title: const Text('消息'),
          ),
          body: SingleChildScrollView(
            padding:
                const EdgeInsets.only(left: 4, right: 4, top: 15, bottom: 15),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: chatList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                return Slidable(
                  key: ValueKey(index),
                  enabled: false,
                  endActionPane: null,
                  startActionPane: ActionPane(
                    extentRatio: 0.18,
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        icon: Icons.delete_sharp,
                        onPressed: (context) {
                          _deleteDialog(context, () async {
                            chatList.removeAt(index);
                            // await userBox.put('chatList', chatList);
                          });
                        },
                      ),
                    ],
                  ),
                  child: MenuAnchor(
                    childFocusNode: _buttonFocusNode,
                    alignmentOffset: menuAnchorPosition,
                    menuChildren: <Widget>[
                      MenuItemButton(
                        onPressed: () {},
                        child: const Text('置顶聊天'),
                      ),
                      MenuItemButton(
                        onPressed: () {},
                        child: const Text('删除聊天'),
                      ),
                    ],
                    builder: (_, MenuController controller, Widget? child) {
                      Map chatItem = chatList[index];
                      List chatItemMsgs =
                          MessageUtil.getMessages(chatItem['account']);

                      Map msgData = _getMessageData(chatItemMsgs);

                      return GestureDetector(
                        onLongPressDown: (details) {
                          if (!controller.isOpen) {
                            setState(() {
                              menuAnchorPosition =
                                  Offset(details.localPosition.dx, -20);
                            });
                          }
                        },
                        child: ListTile(
                          enabled: true,
                          onTap: () {
                            if (controller.isOpen) {
                              controller.close();
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatPage(item: chatItem),
                                ),
                              );
                            }
                          },
                          onLongPress: () {
                            if (controller.isOpen) {
                              controller.close();
                            } else {
                              controller.open();
                            }
                          },
                          leading: Container(
                            alignment: Alignment.center,
                            width: 52,
                            height: 52,
                            // color: Colors.pink,
                            child: Image.network(chatItem['avatar']),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                chatList[index]['name'],
                                style: const TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                              Text(msgData['sendTime'])
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(msgData['content']),
                              Badge.count(
                                count: msgData['newCount'],
                                backgroundColor: const Color(
                                  0xFFf5a13c,
                                ),
                                isLabelVisible: msgData['newCount'] > 0,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Map _getMessageData(List messages) {
    Map m = {'newCount': 0, 'sendTime': '', 'content': ''};

    if (messages.isNotEmpty) {
      m['content'] = _getFormatMsgContent(messages.last);
      m['sendTime'] = getDateTime(messages.last['sendTime']);
      m['newCount'] = (<dynamic>[0] + messages)
          .reduce((value, element) => value + (element['read'] == 1 ? 1 : 0));
    }

    return m;
  }

  String _getFormatMsgContent(Map msg) {
    int type = msg['type'];
    String ctx = '';
    if (type == MessageType.text.value) {
      ctx += msg['content'];
    } else if (type == MessageType.image.value) {
      ctx += '图片';
    } else if (type == MessageType.voice.value) {
      ctx += '语音';
    }

    return "${msg['read'] == 1 ? '[新消息]' : ''} $ctx";
  }
}

Future _deleteDialog(BuildContext context, Function? callback) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('确定删除吗？'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (callback != null) {
                callback();
              }
            },
            child: const Text('确定'),
          ),
        ],
      );
    },
  );
}
