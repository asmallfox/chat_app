import 'package:chat_app/Apis/modules/user.dart';
import 'package:chat_app/CustomWidget/custom_text_input.dart';
import 'package:chat_app/CustomWidget/loading_filled_button.dart';
import 'package:chat_app/Screens/Home/home.dart';
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
  bool _loginBtnDisabled = true;
  bool _loginBtnLoading = false;

  Future<void> submit() async {
    setState(() {
      _loginBtnLoading = true;
      _loginBtnDisabled = true;
    });
    try {
      Map<String, String> formData = {
        'username': _usernameController.text,
        'password': _passwordController.text
      };

      Map<String, dynamic> res = await loginRequest(formData);
      Map<String, dynamic> user = res['data'];
      String token = user['token'];
      LocalStorage.setItem('token', token);
      LocalStorage.setItem('user', user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } catch (err) {
      print('[请求出错了]: ${err.toString()}');
    } finally {
      print('请求完成');
      setState(() {
        _loginBtnLoading = false;
        _loginBtnDisabled = false;
      });
    }
  }

  void _updateButtonState(_) {
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      setState(() {
        _loginBtnDisabled = false; // 按钮启用
      });
    } else {
      setState(() {
        _loginBtnDisabled = true; // 按钮禁用
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: 'xxx001');
    _passwordController = TextEditingController(text: '123456');
    _updateButtonState(null);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    // _usernameController.addListener(_updateButtonState);
    // _passwordController.addListener(_updateButtonState);
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
                onChanged: _updateButtonState,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextInput(
                labelText: '密码',
                controller: _passwordController,
                onChanged: _updateButtonState,
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
                    ),
                  ),
                ],
              ),
              LoadingFilledButton(
                loading: _loginBtnLoading,
                onPressed: _loginBtnDisabled ? null : submit,
                child: const Text('登录'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
