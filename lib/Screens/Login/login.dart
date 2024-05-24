import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          TextField(
            controller: _usernameController,
            obscureText: true,
            decoration:
                InputDecoration(border: OutlineInputBorder(), labelText: '账号'),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration:
                InputDecoration(border: OutlineInputBorder(), labelText: '密码'),
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton.extended(
              onPressed: () {
                print('login');
                print("username: $_usernameController.text, password: $_passwordController.text");
              },
              label: const Text('登录'))
        ],
      ),
    )));
  }
}
