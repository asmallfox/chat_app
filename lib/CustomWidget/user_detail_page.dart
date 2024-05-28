import 'package:chat_app/Apis/modules/user.dart';
import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/Helpers/show_tip_message.dart';
import 'package:flutter/material.dart';

class UserDetailPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const UserDetailPage({
    super.key,
    required this.user,
  });

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final Map<String, dynamic> currentUser = LocalStorage.getMapItem('user');

  Future<void> handleAddFriend(BuildContext context) async {
    try {
      final params = {
        'id': currentUser['id'],
        'userId': widget.user['id']
      };
      print(widget.user['id'].runtimeType.toString());
      await addFriendRequest(params);
    } catch (err) {
      showTipMessage(context, '添加失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    String avatar = widget.user['avatar'] ?? '';

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      image: DecorationImage(
                        image: avatar.isEmpty
                            ? const AssetImage(
                                'assets/images/default_avatar.png',
                              )
                            : NetworkImage(avatar),
                      ),
                      borderRadius: BorderRadius.circular(8)),
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.user['nickname'],
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          widget.user['sex'] == 1 ? Icons.man : Icons.woman,
                          color: widget.user['sex'] == 1
                              ? Colors.blue[300]
                              : Colors.pink[300],
                        )
                      ],
                    ),
                    Text(
                      '账号：${widget.user['username']}',
                      style: TextStyle(color: Colors.grey.shade500),
                    )
                  ],
                ),
              ],
            ),
            FilledButton(
              onPressed: () {
                handleAddFriend(context);
              },
              style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: Colors.grey.shade400),
              child: const Text('添加好友'),
            )
          ],
        ),
      ),
    );
  }
}
