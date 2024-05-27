import 'dart:convert';

import 'package:chat_app/Apis/modules/user.dart';
import 'package:chat_app/CustomWidget/form/CustomTextInput.dart';
import 'package:chat_app/Screens/Login/register.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Helpers/local_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  Future<void> submit() async {
    try {
      Map<String, String> formData = {
        'username': _usernameController.text,
        'password': _passwordController.text
      };
      if (formData['username'] == null || formData['password'] == null) {
        print('用户名 或 密码不能为空');
        return;
      }
      dynamic res = await loginRequest(formData);
      String token = res['data'];
      if (token.isNotEmpty) {
        LocalStorage.setItem('token', token);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const HomePage(),
        //   ),
        // );
      }
      print(token);
    } catch (err) {
      print(err);
    } finally {}
  }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: 'xxx001');
    _passwordController = TextEditingController(text: '123456');
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CustomTextInput(
                labelText: '用户名',
                controller: _usernameController,
                // onChanged: usernameChange,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextInput(
                labelText: '密码',
                controller: _passwordController,
                // onChanged: passwordChange,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        print('去注册');
                        Navigator.push(
                          context,
                          PageRouteBuilder<void>(
                            pageBuilder: (BuildContext context, _, __) {
                              return RegisterPage();
                            },
                          ),
                        );
                      },
                      child: Text(
                        '没账号？去注册',
                        style: TextStyle(
                          color: Colors.blue[800],
                        ),
                      ))
                ],
              ),
              LoginButton(
                onPressed: submit,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final void Function()? onPressed;

  const LoginButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      label: const Text('登录'),
    );
  }
}
