import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/search_user_page.dart';
import 'package:chat_app/Helpers/animation_slide_route.dart';
import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/Screens/AddressBook/friend_verification.dart';
import 'package:chat_app/Screens/Message/chat.dart';
import 'package:chat_app/provider/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({super.key});

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  final user = LocalStorage.getUserInfo();
  Box userBox = LocalStorage.getUserBox();

  late List friends = userBox.get('friends', defaultValue: []);

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
        child: ValueListenableBuilder(
          valueListenable: userBox.listenable(keys: ['friends']),
          builder: (context, value, _) {
            return Column(
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
                  itemCount: friends.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 15),
                  itemBuilder: (context, index) {
                    final item = friends[index];
                    final avatarUrl = item['avatar']?.toString() ?? '';
                    return ListTile(
                      leading: Avatar(
                        imageUrl: avatarUrl,
                        size: 46,
                        circular: true,
                      ),
                      title: Text(item['nickname']),
                      onTap: () {
                        Provider.of<ChatModel>(context, listen: false)
                            .setChat(item);
                        Navigator.push(
                          context,
                          animationSlideRoute(Chat(chatItem: item)),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// alignment: Alignment.center,
//   // decoration: BoxDecoration(
//   //   color: Color.fromRGBO(
//   //     Random().nextInt(256),
//   //     Random().nextInt(256),
//   //     Random().nextInt(256),
//   //     1.0,
//   //   ),
//   //   borderRadius: BorderRadius.circular(6.0),
//   // ),
//   child: 
