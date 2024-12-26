import 'package:chat_app/src/constants/global_key.dart';
import 'package:chat_app/src/helpers/global_notification.dart';
import 'package:chat_app/src/helpers/recording_helper.dart';
import 'package:chat_app/src/providers/model/chat_provider_model.dart';
import 'package:chat_app/src/socket/socket_api.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  const TestPage({
    super.key,
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: Column(
        children: [
          FilledButton(
            onPressed: () {
              _call();
            },
            child: Text('audio'),
          ),
        ],
      ),
    );
  }

  void _call() {
    GlobalNotification.send({
      'payload': 'audio'
    });
    // SocketApi.callSocketApi(
    //   {
    //     'id': 2,
    //     'account': 'lisi',
    //   },
    //   (data) {
    //     print('结果： ￥data');
    //   },
    // );
  }
}
