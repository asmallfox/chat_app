import 'dart:math';

import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/search_user_page.dart';
import 'package:chat_app/Helpers/animation_slide_route.dart';
import 'package:chat_app/Screens/AddressBook/friend_verification.dart';
import 'package:chat_app/Screens/Message/chat.dart';
import 'package:flutter/material.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({super.key});

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  final List<Map<String, dynamic>> userList = List.generate(30, (index) {
    return {
      "id": index,
      "username": 'username${index + 1}',
      "nickname": '好友${index + 1}',
      "avatar": null,
    };
  });
  //
  // @override
  // Future<void> initState() async {}
  //
  // Future<void> getUserList() async {
  //   try {
  //     const res = await
  //     userList = [];
  //   } catch (error) {}
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("通知"),
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {
                Navigator.push(
                  context,
                  animationSlideRoute(
                    const FriendVerification(),
                  ),
                );
              },
            ),
            ListView.builder(
              itemCount: userList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 15),
              itemBuilder: (context, index) {
                var item = userList[index];
                return ListTile(
                  leading: Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(
                        Random().nextInt(256),
                        Random().nextInt(256),
                        Random().nextInt(256),
                        1.0,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(item['nickname']),
                  onTap: () {
                    Navigator.push(
                      context,
                      animationSlideRoute(Chat(item: item)),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
