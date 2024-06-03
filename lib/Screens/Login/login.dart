import 'package:chat_app/Apis/modules/user.dart';
import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/custom_text_form_field.dart';
import 'package:chat_app/CustomWidget/loading_filled_button.dart';
import 'package:chat_app/Helpers/animation_slide_route.dart';
import 'package:chat_app/Screens/Home/home.dart';
import 'package:chat_app/Screens/Login/register.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool _loginBtnLoading = false;

  Future<void> _submit(BuildContext context) async {
    setState(() {
      _loginBtnLoading = true;
    });
    try {
      Map<String, String> formData = {
        'username': _usernameController.text,
        'password': _passwordController.text
      };

      var res = await loginRequest(formData);
      Map<String, dynamic> user = res.data;

      await Hive.box('settings').put('token', user['token']);
      await Hive.box('settings').put('user', user);

      if (!context.mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    } catch (err) {
      print('登录失败: ${err.toString()}');
    } finally {
      setState(() {
        _loginBtnLoading = false;
      });
    }
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
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 120),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Avatar(
                  size: 100,
                  image: AssetImage('assets/images/default_avatar.png'),
                ),
                const SizedBox(height: 60),
                CustomTextFormField(
                  labelText: "账号",
                  controller: _usernameController,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextFormField(
                  labelText: "密码",
                  obscureText: true,
                  controller: _passwordController,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          animationSlideRoute(const RegisterPage()),
                        );
                      },
                      child: Text(
                        '没有账号？去注册',
                        style: TextStyle(
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LoadingFilledButton(
                      height: 50,
                      loading: _loginBtnLoading,
                      onPressed: () => _submit(context),
                      child: const Text(
                        "登录",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
