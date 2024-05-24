import 'package:chat_app/CustomWidget/form/CustomTextInput.dart';
import 'package:chat_app/Screens/Home/home.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage();

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextInput(
              labelText: '用户名',
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextInput(
              labelText: '密码',
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextInput(
              labelText: '确认密码',
            ),
            SizedBox(
              height: 20,
            ),
            FloatingActionButton(
                onPressed: () {
                  print('注册');
                  Navigator.pop(context);
                  // Navigator.(context, PageRouteBuilder(pageBuilder: (context, _ ,__) {
                  //   return HomePage();
                  // }));
                },
                child: Text('注册'))
          ],
        ),
      ),
    );
  }
}
