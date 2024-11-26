import 'package:chat_app/src/socket/socket_api.dart';
import 'package:chat_app/src/socket/socket_io_client.dart';
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
                subtitle: Text(item['info'].toString()),
                trailing: FilledButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  onPressed: item['status'] == 1
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('好友验证'),
                                content: const Text('是否同意该好友请求?'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => _handleRefuse(item),
                                    child: const Text(
                                      '拒绝',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => _handleAgree(item),
                                    child: const Text('同意'),
                                  )
                                ],
                              );
                            },
                          );
                        }
                      : null,
                  child: Text(_getBtnText(item['status'])),
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

  String _getBtnText(int status) {
    if (status == 1) {
      return '验证';
    } else if (status == 3) {
      return '已拒绝';
    }
    return '已添加';
  }

  void _handleRefuse(Map item) {
    Map params = {
      'id': item['id'],
      'status': 3,
      'info': null,
    };
    try {
      SocketApi.refuseFriendVerifySocketApi(params, (data) {
        print('================ $data');
      });
    } catch (error) {
      print(error);
    }

    Navigator.pop(context);
  }

  void _handleAgree(Map item) {
    Navigator.pop(context);
  }
}
