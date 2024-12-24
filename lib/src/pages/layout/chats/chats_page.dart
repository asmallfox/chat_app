import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/pages/layout/chats/chats_conversation_page.dart';
import 'package:chat_app/src/utils/get_date_time.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({
    super.key,
  });

  @override
  State<ChatsPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatsPage> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
  Offset menuAnchorPosition = const Offset(0, 0);

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
      valueListenable: UserHive.box.listenable(keys: ['chatList']),
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

                      Map friend = UserHive.friends.firstWhere((element) =>
                          element['account'] == chatItem['account']);

                      Map msgData =
                          _getMessageData(friend['messages'], chatItem);

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
                                      ChatsConversationPage(item: friend),
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
                          leading: Avatar(
                            url: friend['avatar'],
                            radius: 30,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: Text(
                                  friend['name'],
                                  style: const TextStyle(
                                    fontSize: 22,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Text(msgData['time'])
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  msgData['content'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
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

  Map _getMessageData(List messages, Map chatItem) {
    Map m = {
      'content': '',
      'time': '',
      'newCount': 0,
    };

    if (messages.isNotEmpty) {
      final lastMsg = messages.last;
      m['content'] = _getFormatMsgContent(chatItem['account'], lastMsg);
      m['time'] = getDateTime(lastMsg['updatedAt'] ?? lastMsg['sendTime']);
      m['newCount'] = chatItem['newCount'];
    }

    return m;
  }

  String _getFormatMsgContent(String friendAccount, Map msg) {
    int type = msg['type'];
    String ctx = '';

    bool isNewMsg =
        friendAccount == msg['from'] && msg['read'] == ReadStatus.no.value;

    if (type == MessageType.text.value) {
      ctx += msg['content'];
    } else if (type == MessageType.image.value) {
      ctx += '图片';
    } else if (type == MessageType.voice.value) {
      ctx += '语音';
    }

    return "${isNewMsg ? '[新消息]' : ''} $ctx";
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
}
