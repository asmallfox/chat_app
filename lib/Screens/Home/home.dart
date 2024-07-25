import 'package:chat_app/Screens/AddressBook/address_book.dart';
import 'package:chat_app/Screens/Message/chat_audio_page.dart';
import 'package:chat_app/Screens/Message/message.dart';
import 'package:chat_app/Screens/Mine/mine.dart';
import 'package:chat_app/constants/config.dart';
import 'package:chat_app/provider/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.title = 'homePage'});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  late PageController _pageViewController;

  final widgetList = <Map<String, dynamic>>[
    {
      "label": "消息",
      "icon": const Icon(Icons.person_pin_rounded),
      "child": const ChatMessagePage(),
    },
    {
      "label": "通讯录",
      "icon": const Icon(Icons.person_pin_rounded),
      "child": const AddressBook()
    },
    {
      "label": "我的",
      "icon": const Icon(Icons.person_rounded),
      "child": const Mine(),
      "hiddenAppBar": true
    }
  ];

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => ChatAudioPage(
          chatItem: context.read<ChatModelProvider>().communicate!,
        ),
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: 0);
    _configureSelectNotificationSubject();
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
              icon: item['icon'],
              label: item['label'],
            );
          },
        ).toList(),
      ),
    );
  }
}
