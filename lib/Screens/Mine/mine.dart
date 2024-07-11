import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/Screens/Login/login.dart';
import 'package:chat_app/socket/socket_io.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Mine extends StatefulWidget {
  const Mine({super.key});

  @override
  State<Mine> createState() => _MineState();
}

class _MineState extends State<Mine> {
  Map user = {};

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() {
    user = Hive.box('settings').get('user', defaultValue: {});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String avatar = user['avatar'] ?? '';
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Avatar(imageUrl: avatar, size: 60),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              user['nickname'] ?? 'unknown',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              user['sex'] == 1 ? Icons.man : Icons.woman,
                              color: user['sex'] == 1
                                  ? Colors.blue[300]
                                  : Colors.pink[300],
                            )
                          ],
                        ),
                        Text(
                          '账号：${user['username']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            child: const Text('登录'),
            onPressed: () async {
              print('登录');
            },
          ),
          ElevatedButton(
            child: const Text('退出'),
            onPressed: () async {
              await Hive.box('settings').delete('token');
              SocketIOClient.removeSocket();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, _, __) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
