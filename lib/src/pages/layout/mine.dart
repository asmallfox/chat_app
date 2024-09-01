import 'package:chat_app/src/pages/login/log_on_page.dart';
import 'package:flutter/material.dart';

class Mine extends StatefulWidget {
  const Mine({
    super.key,
  });

  @override
  State<Mine> createState() => _MineState();
}

class _MineState extends State<Mine> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Row(
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple[400],
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '小狐幽',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text('账号：smallfox@99'),
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
                onPressed: () {
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
