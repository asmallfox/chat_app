import 'package:chat_app/CustomWidget/search_user_page.dart';
import 'package:chat_app/Screens/AddressBook/address_book.dart';
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
    {
      "label": "消息",
      "icon": const Icon(Icons.person_pin_rounded),
      "child": const ChatMessage()
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

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: 1);
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
        selectedItemColor: Colors.green[800],
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
// import 'package:chat_app/CustomWidget/search_user_page.dart';
// import 'package:chat_app/Screens/AddressBook/address_book.dart';
// import 'package:chat_app/Screens/Message/message.dart';
// import 'package:chat_app/Screens/Mine/mine.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key, this.title = 'homePage'});

//   final String title;

//   @override
//   State<HomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<HomePage> {
//   int currentPageIndex = 0;

//   late PageController _pageViewController;

//   final widgetList = <Map<String, dynamic>>[
//     {
//       "label": "消息",
//       "icon": const Icon(Icons.person_pin_rounded),
//       "child": const ChatMessage()
//     },
//     {
//       "label": "通讯录",
//       "icon": const Icon(Icons.person_pin_rounded),
//       "child": const AddressBook()
//     },
//     {
//       "label": "我的",
//       "icon": const Icon(Icons.person_rounded),
//       "child": const Mine(),
//       "hiddenAppBar": true
//     }
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _pageViewController = PageController(initialPage: 0);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _pageViewController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widgetList[currentPageIndex]["label"]),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.of(context).push(
//                 PageRouteBuilder(
//                   pageBuilder: (_, __, ___) => const SearchUserPage(),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.add_circle_outline),
//           )
//         ],
//       ),
//       body: PageView.builder(
//         itemCount: widgetList.length,
//         controller: _pageViewController,
//         onPageChanged: (index) {
//           setState(() {
//             currentPageIndex = index;
//           });
//         },
//         itemBuilder: (_, index) => widgetList[index]["child"],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentPageIndex,
//         selectedItemColor: Colors.green[800],
//         onTap: (index) {
//           setState(() {
//             _pageViewController.jumpToPage(index);
//           });
//         },
//         items: widgetList.map(
//           (item) {
//             return BottomNavigationBarItem(
//               icon: item['icon'],
//               label: item['label'],
//             );
//           },
//         ).toList(),
//       ),
//     );
//   }
// }
