import 'package:chat_app/CustomWidget/back_icon_button.dart';
import 'package:chat_app/CustomWidget/search_user_page.dart';
import 'package:chat_app/Helpers/animation_slide_route.dart';
import 'package:chat_app/Helpers/socket_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';

class FriendVerification extends StatefulWidget {
  const FriendVerification({super.key});

  @override
  State<FriendVerification> createState() => _FriendVerificationState();
}

class _FriendVerificationState extends State<FriendVerification> {
  final List verifyList = [];

  @override
  void initState() {
    super.initState();
    getVerifyList();
  }

  Future<void> getVerifyList() async {
    try {
      final user = await Hive.box('settings').get('user');
      SocketIO.emit('get_friend_verify', {'userId': user["id"]});
      SocketIO.on('get_friend_verify', (data) {
        setState(() {
          verifyList.addAll(data.first);
        });
      });
    } catch (error) {
      Logger.root.info('Failed to get verify list: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackIconButton(),
        title: const Text('通知'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                animationSlideRoute(
                  const SearchUserPage(),
                ),
              );
            },
            child: const Text('添加好友'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: verifyList.length,
              separatorBuilder: (_, __) {
                return const SizedBox(height: 15);
              },
              itemBuilder: (context, index) {
                var item = verifyList[index];
                String avatar = item['avatar'] ?? "";
                return ListTile(
                  leading: Image(
                    image: avatar.isEmpty
                        ? const AssetImage('assets/images/default_avatar.png')
                        : NetworkImage(avatar),
                  ),
                  title: Text(item['nickname'] ?? '未知用户名'),
                  subtitle:
                      item['message'] == null ? null : Text(item['message']),
                  trailing: getVerifyStatus(item['status']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget? getVerifyStatus(int status) {
  String text = '';
  switch (status) {
    case 1:
      text = '等待验证';
      break;
    case 2:
      text = '已通过';
      break;
    case 3:
    case 4:
      text = '已拒绝';
      break;
  }

  return text.isEmpty ? null : Text(text);
}
