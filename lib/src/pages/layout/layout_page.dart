import 'package:chat_app/src/constants/global_key.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'message/message_list.dart';
import 'addressBook/address_book.dart';
import './mine.dart';

List pageList = [
  {
    'label': '消息',
    "icon": Icons.message_rounded,
    'child': const MessageList(),
    'badge': 0,
  },
  {
    'label': '通讯录',
    "icon": Icons.person_pin_rounded,
    'child': const AddressBook(),
  },
  {
    'label': '我的',
    "icon": Icons.person_rounded,
    'child': const Mine(),
    'hideAppBar': true,
  },
];

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
  }

  @override
  void dispose() {
    _pageViewController.dispose();
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
                )
              ],
            ),
            label: item['label'],
          );
        }).toList(),
      ),
    );
  }
}