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
  final TextEditingController _keywordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardContainer(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 244, 246, 248),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 244, 246, 248),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          leadingWidth: 24,
          title: TextField(
            controller: _keywordController,
            decoration: const InputDecoration(
              hintText: '查找账号',
              border: InputBorder.none,
              fillColor: Colors.white,
              filled: true,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          actions: [
            _keywordController.text.isEmpty
                ? TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('取消'),
                  )
                : TextButton(
                    onPressed: () {},
                    child: const Text('查找'),
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
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(52),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.pink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '张三',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '账号：zs123456',
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () {},
                    child: Text('添加'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
