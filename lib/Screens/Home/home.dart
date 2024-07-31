import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/Screens/AddressBook/address_book.dart';
import 'package:chat_app/Screens/Message/message.dart';
import 'package:chat_app/Screens/Mine/mine.dart';
import 'package:chat_app/constants/config.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.title = 'homePage'});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  late PageController _pageViewController;

  late List chatList = LocalStorage.getUserBox().get('chatList', defaultValue: []);
  int messageCount = 0;

  final widgetList = <Map<String, dynamic>>[
    {
      "label": "消息",
      "icon": Icons.message_rounded,
      "child": const ChatMessagePage(),
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
    messageCount = chatList.reduce((pre, cur) => (pre['newMessageCount'] ?? 0) + cur['newMessageCount'] ?? 0);
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
      bottomNavigationBar: BottomNavigationBar(
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
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Badge(label: Text(messageCount.toString())),
                  ),
                ],
              ),
              label: item['label'],
            );
          },
        ).toList(),
      ),
    );
  }
}
