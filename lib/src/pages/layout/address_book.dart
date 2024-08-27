import 'dart:math';

import 'package:chat_app/src/pages/layout/book_icon_Paint.dart';
import 'package:chat_app/src/utils/get_date_time.dart';
import 'package:chat_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        'name': (index + 1).toString(),
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
  final GlobalKey _ContainerKey = GlobalKey();
  int? highlightedIndex;

  @override
  void initState() {
    super.initState();
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
      _topPosition = renderBox.localToGlobal(Offset.zero).dy;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            key: _ContainerKey,
            // color: Colors.orange,
            width: 20,
            // alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 8),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: keywordList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 1),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onPanUpdate: (details) {
                    final containerRender = _ContainerKey.currentContext!
                        .findRenderObject() as RenderBox;

                    final boxOffset =
                        containerRender.localToGlobal(Offset.zero);

                    final renderBox = context.findRenderObject();
                    final itemHeight = (renderBox?.paintBounds.height ?? 0) /
                        keywordList.length;

                    final index = ((details.globalPosition.dy - boxOffset.dy) /
                            itemHeight)
                        .floor()
                        .clamp(0, keywordList.length - 1);

                    final p = Offset(
                      MediaQuery.of(context).size.width -
                          details.globalPosition.dx +
                          (details.localPosition.dx + 10),
                      (index - 1.5) * itemHeight + _topPosition,
                    );

                    setState(() {
                      keywordPosition = p;
                      highlightedIndex = index;
                    });
                  },
                  onPanEnd: (_) {
                    setState(() {
                      highlightedIndex = null;
                    });
                  },
                  // onPanUpdate: (details) {
                  //   print('======== ${index}');
                  // },
                  // onTapDown: (details) {
                  //   final globalPosition = details.globalPosition;
                  //   final localPosition = details.localPosition;

                  //   final dx = MediaQuery.of(context).size.width -
                  //       globalPosition.dx +
                  //       (localPosition.dx + 10);
                  //   final dy =
                  //       globalPosition.dy - localPosition.dy - _topPosition;

                  //   setState(() {
                  //     keywordPosition = Offset(dx, dy);
                  //   });

                  //   // final elementBox = context.findRenderObject();
                  //   // print('elementBox: ${elementBox?.paintBounds.height} $keywordPosition');
                  // },
                  child: Container(
                    height: 20,
                    width: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: highlightedIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
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
        Positioned(
          right: keywordPosition.dx,
          top: keywordPosition.dy,
          child: AddressBookIcon(),
        )
      ],
    );
  }

  int getActiveIndex() {
    return 1;
  }
}
