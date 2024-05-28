import 'package:chat_app/Apis/modules/user.dart';
import 'package:chat_app/CustomWidget/custom_text_input.dart';
import 'package:chat_app/CustomWidget/loading_filled_button.dart';
import 'package:chat_app/Helpers/show_tip_message.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _loginBtnDisabled = true;
  bool _loginBtnLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: 'test01');
    _passwordController = TextEditingController(text: '123456');
    _confirmPasswordController = TextEditingController(text: '123456');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _loginBtnDisabled = _usernameController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty;
    });
  }

  Future<void> _onRegister(BuildContext context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      showTipMessage(context, '两次密码不一致！');
      return;
    }

    setState(() {
      _loginBtnLoading = true;
      _loginBtnDisabled = true;
    });

    try {
      Map<String, String> formData = {
        'username': _usernameController.text,
        'password': _passwordController.text,
        'confirmPassword': _confirmPasswordController.text
      };
      await registerRequest(formData);
      showTipMessage(context, '注册成功~');
      Navigator.of(context).pop();
    } catch (err) {
      if (err is Map<String, dynamic>) {
        showTipMessage(context, err['message']);
      } else {
        print('Error occurred: $err');
      }
    } finally {
      setState(() {
        _loginBtnLoading = false;
        _loginBtnDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextInput(
              labelText: '用户名',
              controller: _usernameController,
              onChanged: (_) => _updateButtonState(),
            ),
            const SizedBox(height: 20),
            CustomTextInput(
              labelText: '密码',
              controller: _passwordController,
              onChanged: (_) => _updateButtonState(),
            ),
            const SizedBox(height: 20),
            CustomTextInput(
              labelText: '确认密码',
              controller: _confirmPasswordController,
              onChanged: (_) => _updateButtonState(),
            ),
            const SizedBox(height: 20),
            LoadingFilledButton(
              onPressed: () => _onRegister(context),
              loading: _loginBtnLoading,
              enabled: !_loginBtnDisabled,
              child: const Text('注册'),
            )
          ],
        ),
      ),
    );
  }
}
