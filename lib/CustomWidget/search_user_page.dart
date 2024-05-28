import 'package:chat_app/Apis/modules/user.dart';
import 'package:chat_app/CustomWidget/user_detail_page.dart';
import 'package:flutter/material.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({super.key});

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  late TextEditingController _keywordController;

  @override
  void initState() {
    super.initState();
    _keywordController = TextEditingController(text: 'xxx001');
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  Future<void> onSearchUser() async {
    try {
      final params = {'username': _keywordController.text};
      final res = await findUserRequest(params);
      final user = res['data'];
      print(user);
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => UserDetailPage(user: user),
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                // color: Colors.pink[200]
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: TextField(
                  maxLines: 1,
                  controller: _keywordController,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Search User',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 206, 204, 204),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('取消'),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            child: _keywordController.text.isNotEmpty
                ? ListTile(
                    leading: const Icon(Icons.person),
                    title: Text('搜索：${_keywordController.text}'),
                    onTap: onSearchUser,
                  )
                : null,
          )
        ],
      ),
    );
  }
}
