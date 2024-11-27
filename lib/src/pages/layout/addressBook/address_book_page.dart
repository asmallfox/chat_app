import 'dart:convert';
import 'dart:math';

import 'package:chat_app/src/pages/layout/addressBook/add_person_page.dart';
import 'package:chat_app/src/pages/layout/addressBook/group_page.dart';
import 'package:chat_app/src/pages/layout/addressBook/notice_page.dart';
import 'package:chat_app/src/pages/layout/addressBook/widgets/book_icon_Paint.dart';
import 'package:chat_app/src/pages/layout/message/chat_page.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pinyin/pinyin.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' as rootBundle;

const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({
    super.key,
  });

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  List keywordList =
      List.generate(26, (index) => String.fromCharCode(index + 65));

  final GlobalKey _stackGlobalKey = GlobalKey();
  final GlobalKey _containerKey = GlobalKey();
  final iconSize = const Size(70, 55);
  double? _topPosition;
  Offset _keywordPosition = Offset.zero;
  Offset? _containerOffset;
  int? _highlightedIndex;
  List<Widget> widgetList = [];
  final List<Map<String, dynamic>> names = [];
  final ScrollController _scrollController = ScrollController();

  final userInfo = Hive.box('app').get('userInfo');
  Future<void> getFriends() async {
    try {
      final jsonString = await rootBundle.rootBundle
          .loadString('assets/services/friends.json');
      final friends = json.decode(jsonString);
      final localFriends = UserHive.friends;
      if (friends.isNotEmpty) {
        for (int i = 0; i < friends.length; i++) {
          int index = localFriends
              .indexWhere((e) => e['account'] == friends[i]['account']);
          if (index != -1) {
            // 更新信息
            localFriends[index] = {
              ...localFriends[index],
              ...(friends[i] as Map)
            };
          } else {
            localFriends.add(friends[i]);
          }
        }
        UserHive.saveFriends(localFriends);
      }
    } catch (error) {
      print('获取好友列表错误 $error');
    }
  }

  @override
  void initState() {
    super.initState();
    keywordList.insert(0, '~');
    keywordList.add('#');
    getFriends();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPageChanging = Provider.of<bool>(context);
    return ValueListenableBuilder(
      valueListenable: UserHive.box.listenable(keys: ['friends', 'verifyData']),
      builder: (context, box, child) {
        widgetList = _getWidgets(
          box.get('friends', defaultValue: []),
          UserHive.verifyData,
        );
        return Scaffold(
          appBar: AppBar(
            title: const Text('通讯录'),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add_outlined),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddPersonPage(),
                    ),
                  );
                },
              )
            ],
          ),
          body: Stack(
            key: _stackGlobalKey,
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widgetList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) => widgetList[index],
                ),
              ),
              Visibility(
                visible: !isPageChanging,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    key: _containerKey,
                    width: 20,
                    margin: const EdgeInsets.only(right: 8),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: keywordList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onPanUpdate: (details) =>
                              getActiveData(context, details),
                          onTapDown: (details) =>
                              getActiveData(context, details),
                          onPanEnd: (_) => resetHighlightedIndex(),
                          onTapUp: (_) => resetHighlightedIndex(),
                          child: Container(
                            height: 20,
                            width: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _highlightedIndex == index
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text(
                              keywordList[index],
                              style: TextStyle(
                                color: _highlightedIndex == index
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: _highlightedIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _highlightedIndex != null,
                child: Positioned(
                  right: _keywordPosition.dx,
                  top: _keywordPosition.dy,
                  child: CustomPaint(
                    size: iconSize,
                    painter: BookIconPaint(
                      label: keywordList[_highlightedIndex ?? 0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void getActiveData(BuildContext context, dynamic details) {
    if (!(details is DragUpdateDetails || details is TapDownDetails)) return;

    if (_topPosition == null) {
      final RenderBox stackRender =
          _stackGlobalKey.currentContext?.findRenderObject() as RenderBox;

      final stackOffset = stackRender.localToGlobal(Offset.zero);

      final containerRender =
          _containerKey.currentContext!.findRenderObject() as RenderBox;

      _containerOffset = containerRender.localToGlobal(Offset.zero);
      _topPosition = _containerOffset!.dy - stackOffset.dy;
    }

    final renderBox = context.findRenderObject();
    final itemHeight =
        (renderBox?.paintBounds.height ?? 0) / keywordList.length;

    final index =
        ((details.globalPosition.dy - _containerOffset!.dy) / itemHeight)
            .floor()
            .clamp(0, keywordList.length - 1);

    final iconOffset = Offset(
      MediaQuery.of(context).size.width -
          details.globalPosition.dx +
          (details.localPosition.dx + 10),
      _topPosition! + index * itemHeight - (iconSize.height - itemHeight) / 2,
    );

    if (_highlightedIndex != index) {
      String key = keywordList[index];
      int isKeyCount = 0;
      int nameIndex = names.indexWhere((item) {
        if (item['isKey'] == true) {
          isKeyCount++;
        }
        return item['key'] == key && item['isKey'] == true;
      });
      if (key == '~') {
        _scrollController.jumpTo(0);
      } else if (nameIndex != -1) {
        double scrollValue = min(
          _scrollController.position.maxScrollExtent,
          nameIndex * 10 +
              (nameIndex - (isKeyCount - 1)) * 52 +
              (isKeyCount - 1) * 30,
        );

        _scrollController.jumpTo(scrollValue);
      }
    }

    setState(() {
      _highlightedIndex = index;
      _keywordPosition = iconOffset;
    });
  }

  void resetHighlightedIndex() {
    setState(() {
      _highlightedIndex = null;
    });
  }

  List<Widget> _getWidgets(
    List friends,
    Map verifyData,
  ) {
    final Map<String, List<dynamic>> result = {};
    List<Widget> widgets = [];
    List friendList = [...friends];

    friendList.sort(
        (a, b) => a['name'].toLowerCase().compareTo(b['name'].toLowerCase()));

    friendList.insertAll(0, [
      {
        'name': '通知',
        'color': const Color.fromARGB(255, 43, 145, 46),
        'function': true,
        'page': const NoticePage(),
        'badge': verifyData['newCount']
      },
      {
        'name': '群聊',
        'color': const Color.fromARGB(255, 148, 139, 62),
        'function': true,
        'page': const GroupPage(),
        'badge': 0
      }
    ]);

    for (Map item in friendList) {
      String firstChar = item['name'][0];
      String key = PinyinHelper.getPinyin(item['name']).toUpperCase()[0];
      if (item['function'] == true) {
        if (result.containsKey('~')) {
          result['~']!.add(item);
        } else {
          result['~'] = [item];
        }
      } else if (RegExp(r'^[a-zA-Z\u4e00-\u9fa5]').hasMatch(firstChar)) {
        if (result.containsKey(key)) {
          result[key]!.add(item);
        } else {
          result[key] = [item];
        }
      } else {
        if (result.containsKey('#')) {
          result['#']!.add(item);
        } else {
          result['#'] = [item];
        }
      }
    }

    result.forEach((key, value) {
      if (value.isNotEmpty) {
        if (key != '~') {
          widgets.add(SizedBox(
            height: 30,
            child: ListTile(
              title: Text(key),
            ),
          ));
          names.add({
            'key': key,
            'isKey': true,
          });
        }
        names.addAll(value.map((item) {
          return {'key': item['name'], 'isKey': false};
        }));

        widgets.addAll(value.map((item) {
          return SizedBox(
            height: 52,
            child: ListTile(
              onTap: () {
                if (item['page'] == null) {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => ChatPage(item: item),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => item['page'],
                    ),
                  );
                }
              },
              leading: Container(
                alignment: Alignment.center,
                width: 52,
                height: 52,
                color: item['color'] ?? Colors.white,
                child: item['avatar'] == null
                    ? Text(
                        item['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      )
                    : Image.network(item['avatar']),
              ),
              title: Text(
                item['name'],
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
              trailing: Visibility(
                visible: item.containsKey('badge') && item['badge'] > 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Badge(
                    label: Text(
                      (item['badge'] != null && item['badge'] > 99)
                          ? '...'
                          : item['badge'].toString(),
                    ),
                    backgroundColor: const Color(0xFFf5a13c),
                  ),
                ),
              ),
            ),
          );
        }).toList());
      }
    });

    widgets.add(Container(
      height: 50,
      alignment: Alignment.center,
      child: Text('${friendList.length - 2} 个好友'),
    ));

    return widgets;
  }
}
