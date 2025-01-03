import 'dart:async';

import 'package:chat_app/src/api/api.dart';
import 'package:chat_app/src/constants/global_key.dart';
import 'package:chat_app/src/pages/layout/chats/chats_page.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'message/chat_list_page.dart';
import 'addressBook/address_book_page.dart';
import 'mine/mine.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({
    super.key,
  });

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  late PageController _pageViewController;
  int currentPageIndex = 0;
  bool _isPageChanging = false;

  StreamSubscription? _subscription;
  StreamSubscription? _subscription2;

  final List pageList = [
    {
      'label': '消息',
      "icon": Icons.message_rounded,
      'child': const ChatsPage(),
      'badge': 0,
    },
    {
      'label': '通讯录',
      "icon": Icons.person_pin_rounded,
      'child': const AddressBookPage(),
      'badge': 0,
    },
    {
      'label': '我的',
      "icon": Icons.person_rounded,
      'child': const Mine(),
      'hideAppBar': true,
    },
  ];

  Future<void> _getUserInfo() async {
    try {
      final userInfo = AppHive.getCurrentUser;
      if (userInfo != null) {
        final res = await getUserInfoApi({'id': userInfo['id']});

        if (res['data'] != null) {
          UserHive.setBoxData(res['data']);
        }
      }
    } catch (error) {
      print('[Error layout_page]: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: currentPageIndex);
    _pageViewController.addListener(() {
      if (_pageViewController.page != currentPageIndex && !_isPageChanging) {
        setState(() {
          _isPageChanging = true;
        });
      }
    });

    _pageViewController.addListener(() {
      if (_pageViewController.page ==
              _pageViewController.page?.roundToDouble() &&
          _isPageChanging) {
        setState(() {
          _isPageChanging = false;
        });
      }
    });

    _getUserInfo();

    _subscription = UserHive.box.watch(key: 'verifyData').listen((boxEvent) {
      setState(() {
        pageList[1]['badge'] = boxEvent.value?['newCount'] ?? 0;
      });
    });
    _subscription2 = UserHive.box.watch(key: 'chatList').listen((boxEvent) {
      if (boxEvent.value is List && boxEvent.value.isNotEmpty) {
        int count = 0;
        for (int i = 0; i < boxEvent.value.length; i++) {
          count += (boxEvent.value[i]['newCount'] ?? 0) as int;
        }
        setState(() {
          pageList[0]['badge'] = count;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: PageStorageBucket(),
        child: Provider.value(
          value: _isPageChanging,
          child: PageView.builder(
            itemCount: pageList.length,
            controller: _pageViewController,
            itemBuilder: (_, index) => pageList[index]['child'],
            onPageChanged: (index) {
              setState(() {
                currentPageIndex = index;
              });
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: bottomNavBarKey,
        currentIndex: currentPageIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        enableFeedback: false,
        onTap: (index) {
          setState(() {
            _pageViewController.jumpToPage(index);
          });
        },
        items: pageList.map((item) {
          return BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(item['icon'], size: 30),
                Visibility(
                  visible: item['badge'] != null && item['badge'] > 0,
                  child: Positioned(
                    top: 0,
                    right: 0,
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
              ],
            ),
            label: item['label'],
          );
        }).toList(),
      ),
    );
  }
}
