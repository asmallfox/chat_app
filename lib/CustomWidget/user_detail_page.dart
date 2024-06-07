import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/back_icon_button.dart';
import 'package:chat_app/Helpers/show_tip_message.dart';
import 'package:chat_app/Helpers/socket_io.dart';
import 'package:chat_app/constants/status.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
  Future<void> _handleAddFriend(BuildContext context) async {
    var currentUser = await Hive.box('settings').get('user', defaultValue: {});
    try {
      final params = {
        'userId': currentUser['id'],
        'friendId': widget.user['id']
      };
      SocketIO.emit('add_friend', [params]);
    } catch (err) {
      print('error: $err');
      if (!context.mounted) return;
      showTipMessage(context, '添加失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    String avatar = widget.user['avatar'] ?? '';
    return Scaffold(
      appBar: AppBar(
        leading: const BackIconButton(),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [
            Row(
              children: [
                Avatar(imageUrl: avatar, size: 50),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.user['nickname'] ?? '',
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
            const SizedBox(
              height: 30,
            ),
            FilledButton(
              onPressed: () {
                _handleAddFriend(context);
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                widget.user['status'] == verifyStatus['agreed']?['value']
                    ? '发送消息'
                    : '添加好友',
              ),
            )
          ],
        ),
      ),
    );
  }
}
