import 'package:chat_app/CustomWidget/form/CustomTextInput.dart';
import 'package:chat_app/Screens/Home/home.dart';
import 'package:chat_app/Screens/Login/register.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  Map<String, String?> formData = {'username': null, 'password': null};

  void usernameChange(String value) {
    formData['username'] = value;
  }

  void passwordChange(String value) {
    formData['password'] = value;
  }

  void submit() {
    print(formData);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

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
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CustomTextInput(
            labelText: '用户名',
            onChanged: usernameChange,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextInput(
            labelText: '密码',
            onChanged: passwordChange,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    print('去注册');
                    Navigator.push(context, PageRouteBuilder<void>(
                        pageBuilder: (BuildContext context, _, __) {
                      return RegisterPage();
                    }));
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
    )));
  }
}

class LoginButton extends StatelessWidget {
  final void Function()? onPressed;

  const LoginButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        onPressed: onPressed, label: const Text('登录'));
  }
}
