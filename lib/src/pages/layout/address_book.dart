import 'dart:math';

import 'package:chat_app/src/pages/layout/book_icon_Paint.dart';
import 'package:chat_app/src/utils/get_date_time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

class AddressBook extends StatefulWidget {
  const AddressBook({
    super.key,
  });

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  List friends = List.generate(
    100,
    (index) {
      final random = Random();
      return {
        'name':
            letters[random.nextInt(letters.length)] + (index + 1).toString(),
        'date': getDateTime(DateTime.now().microsecond),
        'color': Color.fromARGB(
          255,
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
        )
      };
    },
  );

  List keywordList =
      List.generate(26, (index) => String.fromCharCode(index + 65));

  Offset keywordPosition = Offset.zero;
  double _topPosition = 0;
  final GlobalKey _key = GlobalKey();
  final GlobalKey _containerKey = GlobalKey();
  int? highlightedIndex;
  double itemHeight = 0;
  final iconSize = const Size(70, 55);

  @override
  void initState() {
    super.initState();
    friends.sort(
        (a, b) => a['name'].toLowerCase().compareTo(b['name'].toLowerCase()));
    friends.insertAll(0, [
      {
        'name': '通知',
        'color': const Color.fromARGB(255, 43, 145, 46),
      },
      {
        'name': '群聊',
        'color': const Color.fromARGB(255, 148, 139, 62),
      }
    ]);
    keywordList.add('#');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _key.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        _topPosition = renderBox.localToGlobal(Offset.zero).dy;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPageChanging = Provider.of<bool>(context);
    return Stack(
      key: _key,
      children: [
        SingleChildScrollView(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: friends.length,
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  alignment: Alignment.center,
                  width: 52,
                  height: 52,
                  color: friends[index]['color'],
                  child: Text(
                    friends[index]['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
                title: Text(
                  friends[index]['name'],
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
              );
            },
          ),
        ),
        Visibility(
          visible: !isPageChanging,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              key: _containerKey,
              color: Colors.pink[100],
              width: 20,
              margin: const EdgeInsets.only(right: 8),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: keywordList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onPanUpdate: (details) {
                      final activeData = getActiveData(context, details);
                      setState(() {
                        keywordPosition = activeData['iconOffset'];
                        highlightedIndex = activeData['index'];
                        itemHeight = activeData['itemHeight'];
                      });
                    },
                    onPanEnd: (_) {
                      // setState(() {
                      //   highlightedIndex = null;
                      // });
                    },
                    onTapDown: (details) {
                      final activeData = getActiveData(context, details);
                      setState(() {
                        keywordPosition = activeData['iconOffset'];
                        highlightedIndex = activeData['index'];
                        itemHeight = activeData['itemHeight'];
                      });
                    },
                    onTapUp: (_) {
                      // setState(() {
                      //   highlightedIndex = null;
                      // });
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // color: highlightedIndex == index
                        //     ? Theme.of(context).colorScheme.primary
                        //     : Colors.transparent,
                        color: Color.fromARGB(
                          255,
                          Random().nextInt(256),
                          Random().nextInt(256),
                          Random().nextInt(256),
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Text(
                        keywordList[index],
                        style: TextStyle(
                          color: highlightedIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: highlightedIndex == index
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
          visible: highlightedIndex != null,
          child: Positioned(
            right: keywordPosition.dx,
            top: keywordPosition.dy,
            child: CustomPaint(
              size: iconSize,
              painter: BookIconPaint(
                label: keywordList[highlightedIndex ?? 0],
              ),
            ),
          ),
        ),
        Positioned(
          top: _topPosition,
          right: 45,
          child: Container(
            color: Colors.pink,
            width: 100,
            height: 200,
            child: Text(_topPosition.toString()),
          ),
        )
      ],
    );
  }

  Map<String, dynamic> getActiveData(BuildContext context, dynamic details) {
    if (!(details is DragUpdateDetails || details is TapDownDetails)) {
      return {
        'index': null,
        'iconOffset': Offset.zero,
      };
    }

    final containerRender =
        _containerKey.currentContext!.findRenderObject() as RenderBox;

    final boxOffset = containerRender.localToGlobal(Offset.zero);

    final renderBox = context.findRenderObject();
    final itemHeight =
        (renderBox?.paintBounds.height ?? 0) / keywordList.length;

    final index = ((details.globalPosition.dy - boxOffset.dy) / itemHeight)
        .floor()
        .clamp(0, keywordList.length - 1);

    final iconOffset = Offset(
      MediaQuery.of(context).size.width -
          details.globalPosition.dx +
          (details.localPosition.dx + 10),
      boxOffset.dy,
    );
    print(_topPosition);
    print(boxOffset.dy);
    print(containerRender.globalToLocal(Offset(0, _topPosition)));

    return {
      'index': index,
      'iconOffset': iconOffset,
      'itemHeight': itemHeight,
    };
  }
}
