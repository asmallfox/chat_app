import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/socket/socket_api.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({
    super.key,
  });

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
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
          return verifyList.isEmpty
              ? const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('暂无数据~'),
                  ),
                )
              : ListView.separated(
                  itemCount: verifyList.length,
                  separatorBuilder: (context, _) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final item = verifyList[index];
                    final itemStatus = _getBtnStatus(item);
                    return ListTile(
                      leading: Avatar(
                        url: item['avatar'],
                      ),
                      title: Text(item['name'].toString()),
                      subtitle: Text(
                          item['info'] == null ? '' : item['info'].toString()),
                      trailing: TextButton(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        onPressed: itemStatus['disabled']
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('好友验证'),
                                      content: const Text('是否同意该好友请求?'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              _handleFriendVerify(item, false),
                                          child: const Text(
                                            '拒绝',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              _handleFriendVerify(item, true),
                                          child: const Text('同意'),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                        child: Text(itemStatus['text']),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  void _handleRead() {
    final verifyData = UserHive.verifyData;
    verifyData['newCount'] = 0;
    UserHive.box.put('verifyData', verifyData);
  }

  Map<String, dynamic> _getBtnStatus(Map item) {
    Map<String, dynamic> result = {
      'text': '',
      'disabled': false,
    };

    if (item['status'] == 1) {
      bool isSelf = item['lastOperator'] == UserHive.userInfo['id'];
      result['text'] = isSelf ? '等待验证' : '验证';
      result['disabled'] = isSelf;
    } else if (item['status'] == 2) {
      result['text'] = '已拒绝';
      result['disabled'] = true;
    } else if (item['status'] == 3) {
      result['text'] = '已添加';
      result['disabled'] = true;
    }
    return result;
  }

  void _handleFriendVerify(Map item, bool isAgree) {
    Map params = {
      'id': item['id'],
      'status': isAgree
          ? AddFriendButtonStatus.added.value
          : AddFriendButtonStatus.refuse.value,
      'info': null,
    };
    try {
      SocketApi.friendVerifySocketApi(params, (data) {
        UserHive.updateVerifyData(data, false);
      });
    } catch (error) {
      print(error);
    }

    Navigator.pop(context);
  }
}
