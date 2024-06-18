import 'package:chat_app/Apis/modules/user.dart';
import 'package:chat_app/CustomWidget/linear_gradient_button.dart';
import 'package:chat_app/Helpers/show_tip_message.dart';
import 'package:flutter/material.dart';

import '../../CustomWidget/custom_text_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _nicknameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister(BuildContext context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      showTipMessage(context, '两次密码不一致！');
      return;
    }
    try {
      Map<String, String> formData = {
        'username': _usernameController.text,
        'password': _passwordController.text,
        'confirmPassword': _confirmPasswordController.text
      };
      await registerRequest(formData);
      if (!context.mounted) return;
      showTipMessage(context, '注册成功~');
      Future.delayed(
        const Duration(seconds: 1),
        () => Navigator.of(context).pop(),
      );
    } catch (error) {
      print("注册错误： $error");
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double screenHeight = MediaQuery.of(context).size.height;

    final paddingTop = statusBarHeight + 30.0;

    bool _loading = false;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 20, right: 20, top: paddingTop),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    '注册',
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
                hintText: "名称",
                controller: _nicknameController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                hintText: "用户名",
                controller: _usernameController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                hintText: "密码",
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                hintText: "确认密码",
                obscureText: true,
                controller: _confirmPasswordController,
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearGradientButton(
                    onPressed: () {},
                    loading: _loading,
                    child: const Text(
                      '注册',
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
                    '已有账号？',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
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
                            "登录",
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
}
