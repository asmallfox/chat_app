import 'dart:math';

import 'package:chat_app/src/utils/get_date_time.dart';
import 'package:flutter/material.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({
    super.key,
  });

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  List friends = List.generate(
    100,
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

  List keywordList =
      List.generate(26, (index) => String.fromCharCode(index + 65));

  @override
  void initState() {
    super.initState();
    friends.insertAll(0, [
      {
        'name': '通知',
        'color': const Color.fromARGB(255, 43, 145, 46),
      },
      {
        'name': '群聊',
        'color': const Color.fromARGB(255, 148, 139, 62),
      }
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: friends.length,
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  alignment: Alignment.center,
                  width: 52,
                  height: 52,
                  color: friends[index]['color'],
                  child: Text(
                    friends[index]['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
                title: Text(
                  friends[index]['name'],
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 30, // Set a fixed width
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 8),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: keywordList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 1),
              itemBuilder: (context, index) {
                return Text(
                  keywordList[index],
                  textAlign: TextAlign.center,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
