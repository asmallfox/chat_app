import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

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
        title: const Text('通知'),
      ),
      body: ValueListenableBuilder(
        valueListenable: UserHive.box.listenable(keys: ['verifyData']),
        builder: (context, box, child) {
          final verifyData = UserHive.verifyData;
          final List verifyList = verifyData['data'];
          print(verifyList);
          return ListView.separated(
            itemCount: verifyList.length,
            separatorBuilder: (context, _) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final item = verifyList[index];
              return ListTile(
                leading: Avatar(
                  url: item['receiver_avatar'],
                ),
                title: Text(item['name'].toString()),
                subtitle: Text(item['message'].toString()),
                trailing: FilledButton(
                  child: Text('同意'),
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  onPressed: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _handleRead() {
    verifyData['newCount'] = 0;
    UserHive.box.put('verifyData', verifyData);
  }
}
