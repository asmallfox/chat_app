import 'package:chat_app/CustomWidget/keyboard_container.dart';
import 'package:chat_app/src/pages/layout/addressBook/search_person_page.dart';
import 'package:flutter/material.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({
    super.key,
  });

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  @override
  Widget build(BuildContext context) {
    return KeyboardContainer(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 244, 246, 248),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 244, 246, 248),
          title: const Text('添加好友'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const SearchPersonPage(),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 6,
                  bottom: 20,
                ),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 32,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '账号',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
