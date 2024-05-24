import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.title = 'homePage'});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _counter = 0;

  int currentPageIndex = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: <Widget>[
        Card(
          child: Text('1111')
        ),
        Card(
          child: Text('22222')
        ),
        Card(child: Text('3333'))
      ][currentPageIndex],
     bottomNavigationBar: NavigationBar(
       onDestinationSelected: (int index) {
         setState(() {
           currentPageIndex = index;
         });
       },
       indicatorColor: Colors.green[800],
       selectedIndex: currentPageIndex,
       destinations: const <Widget>[
         NavigationDestination(
           selectedIcon: Icon(Icons.home),
           icon: Icon(Icons.home_outlined),
           label: 'Home',
         ),
         NavigationDestination(
           icon: Badge(child: Icon(Icons.notifications_sharp)),
           label: 'Notifications',
         ),
         NavigationDestination(
           icon: Badge(
             label: Text('2'),
             child: Icon(Icons.messenger_sharp),
           ),
           label: 'Messages',
         ),
       ],
     ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}