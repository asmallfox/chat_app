import 'package:flutter/material.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({
    super.key,
  });

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
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
}
