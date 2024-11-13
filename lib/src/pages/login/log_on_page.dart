import 'dart:convert';

import 'package:chat_app/Helpers/animation_slide_route.dart';
import 'package:chat_app/src/helpers/hive_helper.dart';
import 'package:chat_app/src/helpers/message_helper.dart';
import 'package:chat_app/src/pages/layout/layout_page.dart';
import 'package:chat_app/src/pages/login/widgets/custom_text_field.dart';
import 'package:chat_app/src/pages/login/sign_up_page.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/widgets/key_board_container.dart';
import 'package:chat_app/src/widgets/linear_gradient_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart' as rootBundle;

import 'package:chat_app/src/models/app.dart';
import 'package:chat_app/src/models/user.dart';
import 'package:hive_flutter/adapters.dart';

class LogOnPage extends StatefulWidget {
  const LogOnPage({
    super.key,
  });

  @override
  State<LogOnPage> createState() => _LogOnPageState();
}

class _LogOnPageState extends State<LogOnPage> {
  late TextEditingController _accountController;
  late TextEditingController _passwordController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController(text: 'smallfox@99');
    _passwordController = TextEditingController(text: '123456aa');
  }

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardContainer(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '登录',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              CustomTextField(
                hintText: "账号",
                controller: _accountController,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
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
                  const SizedBox(
                    height: 4,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        animationSlideRoute(const SignUpPage()),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                            "注册",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 6,
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 3,
                          margin: const EdgeInsets.only(top: 6.0),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF6562e3),
                                Color(0xff46a2f5),
                              ],
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onLogin(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    final navigator = Navigator.of(context);

    try {
      Map<String, String> formData = {
        'account': _accountController.text,
        'password': _passwordController.text,
      };
      print('登录数据：$formData');

      // 创建账号数据
      await HiveHelper.openHive(formData['account'].toString());

      final jsonString =
          await rootBundle.rootBundle.loadString('assets/services/user.json');

      final userInfo = json.decode(jsonString);

      // UserHiveModel userModel = UserHiveModel(
      //   id: userInfo['id'],
      //   account: userInfo['account'],
      //   name: userInfo['name'],
      //   avatar: userInfo['avatar'],
      // );
      // AppHiveModel appModel = AppHiveModel(token: 'token', userInfo: userModel);

      // appModel.save();
      // userModel.save();

      // await Hive.box('app').put('token', 'token');
      // await Hive.box('app').put('userInfo', userInfo);

      // await Hive.box(formData['account'].toString()).put('friends', []);

      final appBox = Hive.box('app');

      appBox.putAll({'token': 'token', 'userInfo': userInfo});

      UserHive.box.putAll({
        'friends': [],
        ...UserHive.userInfo,
        ...userInfo,
      });

      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const LayoutPage()),
      );
    } catch (err) {
      print('[error] $err');
      MessageHelper.showModel(
        message: 'Login',
        type: ModelType.error,
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
