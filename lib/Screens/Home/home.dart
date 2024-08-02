import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/Screens/AddressBook/address_book.dart';
import 'package:chat_app/Screens/Message/message.dart';
import 'package:chat_app/Screens/Mine/mine.dart';
import 'package:chat_app/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.title = 'homePage'});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  Box userBox = LocalStorage.getUserBox();

  late PageController _pageViewController;

  final widgetList = <Map<String, dynamic>>[
    {
      "label": "消息",
      "icon": Icons.message_rounded,
      "child": const ChatMessagePage(),
      "badge": 0,
    },
    {
      "label": "通讯录",
      "icon": Icons.person_pin_rounded,
      "child": const AddressBook()
    },
    {
      "label": "我的",
      "icon": Icons.person_rounded,
      "child": const Mine(),
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    selectNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: navigatorKey,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: PageView.builder(
        itemCount: widgetList.length,
        controller: _pageViewController,
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        itemBuilder: (_, index) => widgetList[index]["child"],
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: userBox.listenable(keys: ['chatList']),
        builder: (context, box, _) {
          int msgCount = box.get('chatList').reduce((pre, cur) =>
              (pre['newMessageCount'] ?? 0) + cur['newMessageCount'] ?? 0);

          widgetList[0]['badge'] = msgCount;

          return BottomNavigationBar(
            currentIndex: currentPageIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            enableFeedback: false,
            onTap: (index) {
              setState(() {
                _pageViewController.jumpToPage(index);
              });
            },
            items: widgetList.map(
              (item) {
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
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
