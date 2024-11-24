import 'package:chat_app/src/pages/login/log_on_page.dart';
import 'package:chat_app/src/providers/model/user_provider.dart';
import 'package:chat_app/src/socket/socket_io_client.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/utils/share.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class Mine extends StatefulWidget {
  const Mine({
    super.key,
  });

  @override
  State<Mine> createState() => _MineState();
}

class _MineState extends State<Mine> {
  final userInfo = UserHive.userInfo;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28, left: 20, right: 20),
            child: Row(
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Avatar(
                    url: userInfo['avatar'],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userInfo['name'].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            '账号：',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(userInfo['account'].toString())
                        ],
                      )
                    ],
                  ),
                ),
                const Icon(Icons.keyboard_arrow_right_rounded),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('设置'),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('设置'),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('设置'),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('设置'),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('设置'),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () {},
              ),
              FilledButton(
                onPressed: () async {
                  final appBox = Hive.box('app');
                  UserHive.box.clear();
                  appBox.put('token', null);
                  appBox.put('userInfo', null);
                  SocketIOClient.disconnect(); // 断开socket连接
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const LogOnPage(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.grey),
                ),
                child: const Text('退出登陆'),
              )
            ],
          )
        ],
      ),
    );
  }
}
