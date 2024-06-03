import 'package:chat_app/Screens/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Mine extends StatefulWidget {
  const Mine({super.key});

  @override
  State<Mine> createState() => _MineState();
}

class _MineState extends State<Mine> {
  final Map<String, dynamic> user = Hive.box('settings').get('user', defaultValue: {});
  @override
  Widget build(BuildContext context) {
    String avatar = user['avatar'] ?? '';

    return Column(
      children: [
        Container(
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
                                'assets/images/default_avatar.png')
                            : NetworkImage(avatar),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user['nickname'] ?? '未命名',
                            style: const TextStyle(
                              fontSize: 18,
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
                        style: TextStyle(color: Colors.grey.shade500),
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
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, _, __) => const LoginPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
