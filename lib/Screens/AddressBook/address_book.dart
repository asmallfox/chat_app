import 'package:chat_app/Helpers/animation_slide_route.dart';
import 'package:chat_app/Screens/AddressBook/friend_verification.dart';
import 'package:flutter/material.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({super.key});

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  // late List<Map<String, dynamic>> userList;
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
    return SingleChildScrollView(
      child: Column(
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
          )
        ],
      ),
    );
  }
}
    // child: ListView.builder(
      //   itemCount: userList.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: const Text("标题"),
      //     );
      //   },
      // ),