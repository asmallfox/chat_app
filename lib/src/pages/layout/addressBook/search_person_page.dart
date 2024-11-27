import 'package:chat_app/CustomWidget/keyboard_container.dart';
import 'package:chat_app/Helpers/util.dart';
import 'package:chat_app/src/api/api.dart';
import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/helpers/message_helper.dart';
import 'package:chat_app/src/socket/socket_api.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchPersonPage extends StatefulWidget {
  const SearchPersonPage({
    super.key,
  });

  @override
  State<SearchPersonPage> createState() => _SearchPersonPageState();
}

class _SearchPersonPageState extends State<SearchPersonPage> {
  final TextEditingController _keywordController =
      TextEditingController(text: 'lisi');

  final List _result = [];
  bool _isEmpty = false;

  @override
  Widget build(BuildContext context) {
    return KeyboardContainer(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 244, 246, 248),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 244, 246, 248),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          leadingWidth: 24,
          title: TextField(
            controller: _keywordController,
            decoration: const InputDecoration(
              hintText: '查找账号',
              border: InputBorder.none,
              fillColor: Colors.white,
              filled: true,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          actions: [
            _keywordController.text.isEmpty
                ? TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('取消'),
                  )
                : TextButton(
                    onPressed: () {
                      _onSearch();
                    },
                    child: const Text('查找'),
                  ),
          ],
        ),
        body: _isEmpty
            ? Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(20),
                child: Text(
                  '没有找到数据~',
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
              )
            : ListView.separated(
                itemCount: _result.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final item = _result[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    child: Row(
                      children: [
                        Avatar(url: item['avatar'], radius: 28),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item['name']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '账号：${item['account']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FilledButton(
                          onPressed: item['status'] ==
                                  AddFriendButtonStatus.added.value
                              ? null
                              : () => _onAddFriend(item),
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          child: Text(
                            AddFriendButtonStatus.getText(item['status']),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _onSearch() async {
    try {
      if (_keywordController.text.isEmpty) {
        MessageHelper.showToast(message: '请输入账号');
        return;
      }
      final res = await findUsersApi({'account': _keywordController.text});
      _result.clear();
      _isEmpty = res['data'].isEmpty;
      if (res['data'] is List) {
        setState(() {
          _result.addAll(res['data']);
        });
      }
      print(res);
    } catch (error) {
      print('[Error]: $error');
    }
  }

  Future<void> _onAddFriend(Map item) async {
    try {
      print(item);
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          final TextEditingController infoController = TextEditingController();
          final TextEditingController noteController = TextEditingController();
          return AlertDialog(
            title: const Text('添加好友'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Avatar(
                        radius: 24,
                        url: item['avatar'],
                      ),
                      const SizedBox(width: 16),
                      Text(item['name'])
                    ],
                  ),
                  const SizedBox(height: 28),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '填写验证信息',
                        style: TextStyle(
                          fontSize: 18,
                          height: 2.2,
                        ),
                      ),
                      TextField(
                        minLines: 2,
                        maxLines: 4,
                        controller: infoController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: InputBorder.none,
                          hintText: '请输入验证信息',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '设置对方备注',
                        style: TextStyle(
                          fontSize: 18,
                          height: 2.2,
                        ),
                      ),
                      TextField(
                        controller: noteController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: InputBorder.none,
                          hintText: '请输入验证信息',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FilledButton(
                onPressed: () {
                  Map params = {
                    'friendId': item['id'],
                    'account': item['account'],
                    'info': infoController.text,
                    'note': noteController.text,
                  };
                  SocketApi.addFriendSocketApi(
                    params,
                    (data) => UserHive.updateVerifyData(data, false),
                  );
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                child: const Text('发送'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('[Error]: $error');
    }
  }
}
