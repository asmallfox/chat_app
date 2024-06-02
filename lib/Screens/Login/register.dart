import 'package:chat_app/Apis/modules/user.dart';
import 'package:chat_app/CustomWidget/loading_filled_button.dart';
import 'package:chat_app/Helpers/show_tip_message.dart';
import 'package:flutter/material.dart';

import '../../CustomWidget/custom_text_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _loginBtnDisabled = true;
  bool _loginBtnLoading = false;
  String? _errorText;

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
      if (!context.mounted) return;
      showTipMessage(context, '注册成功~');
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    } catch (error) {
      print("[注册失败], $error");
      _errorText = error as String;
    } finally {
      setState(() {
        _loginBtnLoading = false;
        _loginBtnDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text("注册"),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    CustomTextFormField(
                      hintText: "账号",
                      controller: _usernameController,
                      errorText: _errorText,
                      validator: (value) {
                        if (value == '' || value == null) return "账号不能为空";
                        if (value.toString().length < 6) return "账号长度不能小少6位";
                        return null;
                      },
                      onChanged: (_) {
                        setState(() {
                          _errorText = null;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextFormField(
                      hintText: "密码",
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == '' || value == null) return "密码不能为空";
                        final valLen = value.toString().length;
                        if (valLen < 6 || valLen > 16) {
                          return "密码长度不能小少6位，且不能少于16位";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextFormField(
                      hintText: "确认密码",
                      controller: _confirmPasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == '' || value == null) return "确认密码不能为空";
                        if (value.toString().length < 6) return "";
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoadingFilledButton(
                    height: 50,
                    loading: _loginBtnLoading,
                    onPressed: () => _onRegister(context),
                    child: const Text('注册'),
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
