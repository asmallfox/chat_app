import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/back_icon_button.dart';
import 'package:chat_app/CustomWidget/search_user_page.dart';
import 'package:chat_app/Helpers/animation_slide_route.dart';
import 'package:chat_app/socket/socket_io.dart';
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
  late Map user;

  @override
  void initState() {
    super.initState();
    SocketIOClient.on('get_friend_verify', handleFriendVerify);
    getVerifyList();
  }

  Future<void> getVerifyList() async {
    try {
      user = await Hive.box('settings').get('user');
      SocketIOClient.emit('get_friend_verify', {'userId': user["id"]});
    } catch (error) {
      Logger.root.info('Failed to get verify list: $error');
    }
  }

  void handleFriendVerify(data) {
    setState(() {
      verifyList.addAll(data.first);
    });
  }

  @override
  void dispose() {
    SocketIOClient.off('get_friend_verify');
    super.dispose();
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
                  leading: Avatar(imageUrl: avatar),
                  title: Text(item['nickname'] ?? '未知用户名'),
                  subtitle:
                      item['message'] == null ? null : Text(item['message']),
                  trailing: getVerifyStatus(
                    context,
                    item['status'],
                    user,
                    item,
                  ),
                  onTap: () {
                    print('信息');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget? getVerifyStatus(
  BuildContext context,
  int status,
  Map<dynamic, dynamic> user,
  Map<String, dynamic> item,
) {
  String text = '';
  bool isPromoter = user['id'] == item['promoter'];
  switch (status) {
    case 1:
      text = isPromoter ? '等待验证' : '同意';
      break;
    case 2:
    case 4:
      text = isPromoter ? '已通过' : '已同意';
      break;
    case 3:
      text = isPromoter ? '已拒绝' : '对方拒绝';
      break;
  }

  return text.isEmpty
      ? null
      : TextButton(
          onPressed: () {
            _dialogBuilder(context);
          },
          child: Text(text),
        );
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // title: const Text('好友验证'),
        content: const Text('好友验证'),
        actions: <Widget>[
          TextButton(
            child: const Text('拒绝'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('同意'),
            onPressed: () {
              // SocketIOClient.emit('add_friend_verify', {
                
              // });
              // Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
