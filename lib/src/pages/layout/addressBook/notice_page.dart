import 'package:chat_app/src/utils/hive_util.dart';
import 'package:flutter/material.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({
    super.key,
  });

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {

  final verifyData = UserHive.verifyData;

  @override
  void initState() {
    super.initState();
    _handleRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Page'),
      ),
      body: const Center(
        child: Text('This is the Group Page'),
      ),
    );
  }

  void _handleRead() {
    verifyData['newCount'] = 0;
    UserHive.box.put('verifyData', verifyData);
  }
}
