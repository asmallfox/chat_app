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
    return Container(
      // child: ListView.builder(
      //   itemCount: userList.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: const Text("标题"),
      //     );
      //   },
      // ),
    );
  }
}
