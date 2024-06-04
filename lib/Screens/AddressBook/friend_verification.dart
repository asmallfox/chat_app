import 'package:chat_app/Helpers/socket_io.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';

class FriendVerification extends StatefulWidget {
  const FriendVerification({super.key});

  @override
  State<FriendVerification> createState() => _FriendVerificationState();
}

class _FriendVerificationState extends State<FriendVerification> {
  late List verifyList;

  @override
  void initState() {
    super.initState();
    getVerifyList();
  }

  Future<void> getVerifyList() async {
    try {
      final user = await Hive.box('settings').get('user');

      SocketIO.emit('get_friend_verify', {'userId': user.id});

      SocketIO.on('get_friend_verify', (data) {
        print('接收 $data');
      });
    } catch (error) {
      Logger.root.info('Failed to get verify list: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: verifyList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Friend $index'),
          );
        },
      ),
    );
  }
}
