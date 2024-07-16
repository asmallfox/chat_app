import 'dart:ui';

import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/search_user_page.dart';
import 'package:chat_app/Helpers/animation_slide_route.dart';
import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/Helpers/message.dart';
import 'package:chat_app/Screens/Message/chat.dart';
import 'package:chat_app/provider/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage>
    with TickerProviderStateMixin {
  Box userBox = LocalStorage.getUserBox();

  late List chatList = userBox.get('chatList', defaultValue: []);
  bool showMenu = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('消息'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const SearchUserPage(),
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: userBox.listenable(keys: ['chatList']),
          builder: (context, box, _) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    print('搜索');
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: const Color(0xFFf5f6fa),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 28,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          '搜索~',
                          style: TextStyle(
                            color: Colors.black38,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                chatList.isEmpty
                    ? const ChatEmpty()
                    : SlidableAutoCloseBehavior(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 20.0,
                          ),
                          itemCount: chatList.length,
                          separatorBuilder: (_, __) {
                            return const SizedBox(
                              height: 15,
                            );
                          },
                          itemBuilder: (context, index) {
                            var item = chatList[index];
                            var newMessage =
                                item['messages'][item['messages'].length - 1];
                            int newMessageCount = item['newMessageCount'] > 99
                                ? 99
                                : item['newMessageCount'];

                            return GestureDetector(
                              onTap: () async {
                                item['newMessageCount'] = 0;

                                Provider.of<ChatModel>(context, listen: false)
                                    .setChat(item);
                                Navigator.push(
                                  context,
                                  animationSlideRoute(Chat(chatItem: item)),
                                );

                                await userBox.put('chatList', chatList);
                              },
                              child: Slidable(
                                key: ValueKey(item['friendId']),
                                startActionPane: ActionPane(
                                  extentRatio: 0.18,
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: (BuildContext context) {
                                        _deleteDialog(context, () async {
                                          chatList.removeAt(index);
                                          await userBox.put(
                                              'chatList', chatList);
                                        });
                                      },
                                      icon: Icons.delete_sharp,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer,
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 15.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                              31,
                                              118,
                                              117,
                                              117,
                                            ),
                                            spreadRadius: 0,
                                            blurRadius: 20,
                                            offset: Offset(0, 4),
                                          )
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Avatar(
                                            imageUrl: item['avatar'],
                                            size: 42,
                                            rounded: true,
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        item['nickname'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      newMessage == null
                                                          ? ''
                                                          : getDateTime(
                                                              newMessage[
                                                                  'created_at'],
                                                            ),
                                                      style: TextStyle(
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: newMessage?[
                                                                  'type'] ==
                                                              1
                                                          ? Text(
                                                              "${newMessageCount > 0 ? '[$newMessageCount条] ' : ''}${newMessage['message']}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey[500],
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    ),
                                                    Badge.count(
                                                      count: newMessageCount,
                                                      backgroundColor:
                                                          const Color(
                                                        0xFFf5a13c,
                                                      ),
                                                      isLabelVisible:
                                                          newMessageCount > 0,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
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

class ChatEmpty extends StatelessWidget {
  const ChatEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        top: 30,
      ),
      child: Center(
        child: Text('暂无聊天记录'),
      ),
    );
  }
}
