import 'package:chat_app/CustomWidget/search_user_page.dart';
import 'package:chat_app/Screens/AddressBook/addressBook.dart';
import 'package:chat_app/Screens/Message/message.dart';
import 'package:chat_app/Screens/Mine/mine.dart';
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

  final widgetList = <Map<String, dynamic>>[
    {"title": "消息", "child": const ChatMessage()},
    {"title": "消息", "child": const AddressBook()},
    {"title": "消息", "child": const Mine()}
  ];

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widgetList[currentPageIndex]["title"]),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const SearchUserPage(),
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          )
        ],
      ),
      body: PageView.builder(
          itemCount: widgetList.length,
          controller: _pageViewController,
          onPageChanged: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return (widgetList[index]["child"]);
          }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        selectedItemColor: Colors.green[800],
        onTap: (index) {
          setState(() {
            _pageViewController.jumpToPage(index);
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '消息'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_pin_rounded), label: '通讯录'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: '我'),
        ],
      ),
      // bottomNavigationBar: NavigationBar(
      //   onDestinationSelected: (int index) {
      //     setState(() {
      //       _pageViewController.jumpToPage(index);
      //     });
      //   },
      //   surfaceTintColor: Colors.transparent,
      //   indicatorColor: Colors.green[800],
      //   selectedIndex: currentPageIndex,
      //   destinations: const <Widget>[
      //     NavigationDestination(
      //       selectedIcon: Icon(Icons.home),
      //       icon: Icon(Icons.messenger_sharp),
      //       label: '消息',
      //     ),
      //     NavigationDestination(
      //       icon: Badge(child: Icon(Icons.person_pin_rounded)),
      //       label: '通讯录',
      //     ),
      //     NavigationDestination(
      //       icon: Badge(
      //         label: Text('2'),
      //         child: Icon(Icons.person_rounded),
      //       ),
      //       label: '我',
      //     ),
      //   ],
      // ),
    );
  }
}
