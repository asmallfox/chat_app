import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/Screens/Login/login.dart';
import 'package:flutter/material.dart';

class Mine extends StatefulWidget {
  const Mine({super.key});

  @override
  State<Mine> createState() => _MineState();
}

class _MineState extends State<Mine> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: const Text('登录'),
          onPressed: () async {
            LocalStorage.setItem('token', 'token');
            print('登录');
          },
        ),
        ElevatedButton(
          child: const Text('退出'),
          onPressed: () {
            LocalStorage.remove('token');
            print('退出');
            // Navigator.of(context).pop();
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
