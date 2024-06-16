import 'dart:math';
import 'dart:ui' as ui;

import 'package:chat_app/Apis/modules/user.dart';
import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/custom_text_form_field.dart';
import 'package:chat_app/CustomWidget/keyboard_container.dart';
import 'package:chat_app/CustomWidget/linear_gradient_button.dart';
import 'package:chat_app/CustomWidget/loading_filled_button.dart';
import 'package:chat_app/Helpers/animation_slide_route.dart';
import 'package:chat_app/Screens/Home/home.dart';
import 'package:chat_app/Screens/Login/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool _loading = false;

  Future<void> _onLogin(BuildContext context) async {
    setState(() {
      _loading = true;
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
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    // _usernameController = TextEditingController(text: 'zs');
    // _passwordController = TextEditingController(text: '123456');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double screenHeight = MediaQuery.of(context).size.height;

    final paddingTop = statusBarHeight + 30.0;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: KeyboardContainer(
        child: Container(
          color: Colors.white,
          height: screenHeight,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 20, right: 20, top: paddingTop),
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      '登录',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomTextFormField(
                  hintText: "账号",
                  controller: _usernameController,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextFormField(
                  hintText: "密码",
                  obscureText: true,
                  controller: _passwordController,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          colors: <Color>[
                            Color(0xFF6562e3),
                            Color(0xff46a2f5),
                          ],
                        ).createShader(bounds);
                      },
                      child: const Text(
                        "忘记密码？",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LinearGradientButton(
                      onPressed: () => _onLogin(context),
                      loading: _loading,
                      child: const Text(
                        '登录',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                Column(
                  children: [
                    const Text(
                      '没有账号？',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            "注册",
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4.0,
                              foreground: Paint()
                                ..shader = ui.Gradient.linear(
                                  const Offset(0, 0),
                                  const Offset(400, 22),
                                  const <Color>[
                                    Color(0xFF6562e3),
                                    Color(0xff46a2f5),
                                  ],
                                ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Container(
                                height: 2,
                                width: 20,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF6562e3),
                                      Color(0xff46a2f5),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
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
