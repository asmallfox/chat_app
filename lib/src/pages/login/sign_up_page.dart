import 'package:chat_app/src/widgets/linear_gradient_button.dart';
import 'package:flutter/material.dart';
import '../../widgets/key_board_container.dart';
import './custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _nicknameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _loading = false;

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

  @override
  Widget build(BuildContext context) {
    return KeyboardContainer(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 0.0,
          leading: const SizedBox(
            width: 0,
            height: 0,
          ),
          title: const Text(
            '注册',
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
              CustomTextField(
                hintText: "名称",
                controller: _nicknameController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "用户名",
                controller: _usernameController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "密码",
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
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
                    onPressed: _onRegister,
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

  Future<void> _onRegister() async {
    setState(() {
      _loading = true;
    });

    try {
      Map<String, String> formData = {
        'nickname': _nicknameController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'confirmPassword': _confirmPasswordController.text,
      };

      print('注册数据：$formData');
    } catch (err) {
      print('[error]: $err');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
