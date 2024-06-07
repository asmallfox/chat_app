import 'package:chat_app/Apis/modules/user.dart';
import 'package:chat_app/CustomWidget/user_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

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
    _keywordController = TextEditingController();
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  Future<void> onSearchUser() async {
    try {
      final params = {'username': _keywordController.text};
      print('xxx $params');
      final res = await findUserRequest(params);
      final user = res.data;

      if (!context.mounted) return;
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => UserDetailPage(user: user),
        ),
      );
    } catch (error) {
      Logger.root.info('搜索用户失败: $error');
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
            onPressed: () {
              Navigator.of(context).pop();
            },
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
