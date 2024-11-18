import 'package:chat_app/CustomWidget/keyboard_container.dart';
import 'package:chat_app/Helpers/util.dart';
import 'package:chat_app/src/api/api.dart';
import 'package:chat_app/src/helpers/message_helper.dart';
import 'package:flutter/material.dart';

class SearchPersonPage extends StatefulWidget {
  const SearchPersonPage({
    super.key,
  });

  @override
  State<SearchPersonPage> createState() => _SearchPersonPageState();
}

class _SearchPersonPageState extends State<SearchPersonPage> {
  final TextEditingController _keywordController =
      TextEditingController(text: 'smallfox@99');

  List _result = [];
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
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600
                  ),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(52),
                          child: SizedBox(
                            width: 52,
                            height: 52,
                            child: Image.network(
                                getNetworkSourceUrl(item['avatar'])),
                          ),
                        ),
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
                          onPressed: () {},
                          child: Text('添加'),
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
}
