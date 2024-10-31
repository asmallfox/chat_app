import 'dart:math';

import 'package:chat_app/src/utils/get_date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import './chat_page.dart';

class MessageList extends StatefulWidget {
  const MessageList({
    super.key,
  });

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
  Offset menuAnchorPosition = const Offset(0, 0);

  List chatList = List.generate(
    20,
    (index) {
      final random = Random();
      return {
        'name': (index + 1).toString(),
        'date': getDateTime(DateTime.now().microsecond),
        'color': Color.fromARGB(
          255,
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
        )
      };
    },
  );

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
    return Scaffold(
      appBar: AppBar(title: const Text('消息')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 4, right: 4, top: 15, bottom: 15),
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
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ChatPage(),
                          ));
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
                        color: chatList[index]['color'],
                        child: Text(
                          chatList[index]['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
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
                          Text(chatList[index]['date'])
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('[新消息] ' + chatList[index]['name']),
                          Badge.count(
                            count: 99,
                            backgroundColor: const Color(
                              0xFFf5a13c,
                            ),
                            isLabelVisible: index % 10 == 2,
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
