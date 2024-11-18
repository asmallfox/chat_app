import 'package:chat_app/src/api/api.dart';
import 'package:chat_app/src/helpers/message_helper.dart';
import 'package:chat_app/src/widgets/linear_gradient_button.dart';
import 'package:flutter/material.dart';
import '../../widgets/key_board_container.dart';
import 'widgets/custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _nameController;
  late TextEditingController _accountController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _accountController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _accountController.dispose();
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
                controller: _nameController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "用户名",
                controller: _accountController,
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

  bool _vaildFormData() {
    String? errorMessage;
    if (_nameController.text.isEmpty) {
      errorMessage = '用户名不能为空';
    } else if (_accountController.text.isEmpty) {
      errorMessage = '账户不能为空';
    } else if (_passwordController.text.isEmpty) {
      errorMessage = '密码不能为空';
    } else if (_confirmPasswordController.text.isEmpty) {
      errorMessage = '确认密码不能为空';
    } else if (_passwordController.text != _confirmPasswordController.text) {
      errorMessage = '两次密码不一致！';
    }
    if (errorMessage != null) {
      MessageHelper.showToast(context: context, message: errorMessage);
    }
    return true;
  }

  Future<void> _onRegister() async {
    if (!_vaildFormData()) return;

    try {
      setState(() {
        _loading = true;
      });
      Map<String, String> formData = {
        'name': _nameController.text,
        'account': _accountController.text,
        'password': _passwordController.text,
        'confirmPassword': _confirmPasswordController.text,
      };
      // print('注册数据：$formData');
      // Map params = {
      //   'name': '小狐幽',
      //   'account': 'smallfox@99111121222211',
      //   'password': '123456',
      //   'confirmPassword': '123456',
      // };

      await registerApi(formData);

      if (mounted) {
        MessageHelper.showToast(message: '注册成功，请前往登陆');
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      }
    } catch (error) {
      print('[error]: $error');
      if (mounted && error is Map) {
        MessageHelper.showToast(context: context, message: error['message']);
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
