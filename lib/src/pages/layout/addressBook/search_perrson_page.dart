import 'package:chat_app/CustomWidget/keyboard_container.dart';
import 'package:flutter/material.dart';

class SearchPerrsonPage extends StatefulWidget {
  const SearchPerrsonPage({
    super.key,
  });

  @override
  State<SearchPerrsonPage> createState() => _SearchPerrsonPageState();
}

class _SearchPerrsonPageState extends State<SearchPerrsonPage> {
  @override
  Widget build(BuildContext context) {
    return KeyboardContainer(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 244, 246, 248),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 244, 246, 248),
          leading: SizedBox(width: 0),
          leadingWidth: 0,
          title: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.clear),
              hintText: '账号',
              helperText: 'supporting text',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text('取消'),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.all(20),
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
              // child: TextField(
              //   decoration: InputDecoration(
              //     prefixIcon: Icon(Icons.search),
              //     suffixIcon: Icon(Icons.clear),
              //     labelText: 'Filled',
              //     hintText: 'hint text',
              //     helperText: 'supporting text',
              //     filled: true,
              //   ),
              // ),
            )
          ],
        ),
      ),
    );
  }
}
