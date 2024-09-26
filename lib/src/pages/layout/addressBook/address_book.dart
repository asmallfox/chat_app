import 'dart:math';

import 'package:chat_app/src/pages/layout/addressBook/book_icon_Paint.dart';
import 'package:chat_app/src/utils/get_date_time.dart';
import 'package:flutter/material.dart';
import 'package:pinyin/pinyin.dart';
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

  final GlobalKey _stackGlobalKey = GlobalKey();
  final GlobalKey _containerKey = GlobalKey();
  final iconSize = const Size(70, 55);
  double? _topPosition;
  Offset _keywordPosition = Offset.zero;
  Offset? _containerOffset;
  int? _highlightedIndex;
  final List<Widget> widgets = [];
  final List<Map<String, dynamic>> names = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initWidgets();
    keywordList.insert(0, '~');
    keywordList.add('#');
  }

  void initWidgets() {
    final Map<String, List<dynamic>> result = {};
    friends.sort(
        (a, b) => a['name'].toLowerCase().compareTo(b['name'].toLowerCase()));

    friends.insertAll(0, [
      {
        'name': '通知',
        'color': const Color.fromARGB(255, 43, 145, 46),
        'function': true,
      },
      {
        'name': '群聊',
        'color': const Color.fromARGB(255, 148, 139, 62),
        'function': true,
      }
    ]);

    for (Map item in friends) {
      String firstChar = item['name'][0];
      String key = PinyinHelper.getPinyin(item['name']).toUpperCase()[0];
      if (item['function'] == true) {
        if (result.containsKey('~')) {
          result['~']!.add(item);
        } else {
          result['~'] = [item];
        }
      } else if (RegExp(r'^[a-zA-Z\u4e00-\u9fa5]').hasMatch(firstChar)) {
        if (result.containsKey(key)) {
          result[key]!.add(item);
        } else {
          result[key] = [item];
        }
      } else {
        if (result.containsKey('#')) {
          result['#']!.add(item);
        } else {
          result['#'] = [item];
        }
      }
    }

    result.forEach((key, value) {
      if (value.isNotEmpty) {
        if (key != '~') {
          widgets.add(SizedBox(
            height: 30,
            child: ListTile(
              title: Text(key),
            ),
          ));
          names.add({
            'key': key,
            'isKey': true,
          });
        }
        names.addAll(value.map((item) {
          return {'key': item['name'], 'isKey': false};
        }));

        widgets.addAll(value.map((item) {
          return SizedBox(
            height: 52,
            child: ListTile(
              leading: Container(
                alignment: Alignment.center,
                width: 52,
                height: 52,
                color: item['color'],
                child: Text(
                  item['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
              title: Text(
                item['name'],
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          );
        }).toList());
      }
    });

    widgets.add(Container(
      height: 50,
      alignment: Alignment.center,
      child: Text('${friends.length - 2} 个好友'),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPageChanging = Provider.of<bool>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('通讯录'),
      ),
      body: Stack(
        key: _stackGlobalKey,
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widgets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) => widgets[index],
            ),
          ),
          Visibility(
            visible: !isPageChanging,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                key: _containerKey,
                width: 20,
                margin: const EdgeInsets.only(right: 8),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: keywordList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onPanUpdate: (details) => getActiveData(context, details),
                      onTapDown: (details) => getActiveData(context, details),
                      onPanEnd: (_) => resetHighlightedIndex(),
                      onTapUp: (_) => resetHighlightedIndex(),
                      child: Container(
                        height: 20,
                        width: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _highlightedIndex == index
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Text(
                          keywordList[index],
                          style: TextStyle(
                            color: _highlightedIndex == index
                                ? Colors.white
                                : Colors.black,
                            fontWeight: _highlightedIndex == index
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
            visible: _highlightedIndex != null,
            child: Positioned(
              right: _keywordPosition.dx,
              top: _keywordPosition.dy,
              child: CustomPaint(
                size: iconSize,
                painter: BookIconPaint(
                  label: keywordList[_highlightedIndex ?? 0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getActiveData(BuildContext context, dynamic details) {
    if (!(details is DragUpdateDetails || details is TapDownDetails)) return;

    if (_topPosition == null) {
      final RenderBox stackRender =
          _stackGlobalKey.currentContext?.findRenderObject() as RenderBox;

      final stackOffset = stackRender.localToGlobal(Offset.zero);

      final containerRender =
          _containerKey.currentContext!.findRenderObject() as RenderBox;

      _containerOffset = containerRender.localToGlobal(Offset.zero);
      _topPosition = _containerOffset!.dy - stackOffset.dy;
    }

    final renderBox = context.findRenderObject();
    final itemHeight =
        (renderBox?.paintBounds.height ?? 0) / keywordList.length;

    final index =
        ((details.globalPosition.dy - _containerOffset!.dy) / itemHeight)
            .floor()
            .clamp(0, keywordList.length - 1);

    final iconOffset = Offset(
      MediaQuery.of(context).size.width -
          details.globalPosition.dx +
          (details.localPosition.dx + 10),
      _topPosition! + index * itemHeight - (iconSize.height - itemHeight) / 2,
    );

    if (_highlightedIndex != index) {
      String key = keywordList[index];
      int isKeyCount = 0;
      int nameIndex = names.indexWhere((item) {
        if (item['isKey'] == true) {
          isKeyCount++;
        }
        return item['key'] == key && item['isKey'] == true;
      });
      if (key == '~') {
        _scrollController.jumpTo(0);
      } else if (nameIndex != -1) {
        double scrollValue = min(
          _scrollController.position.maxScrollExtent,
          nameIndex * 10 +
              (nameIndex - (isKeyCount - 1)) * 52 +
              (isKeyCount - 1) * 30,
        );

        _scrollController.jumpTo(scrollValue);
      }
    }

    setState(() {
      _highlightedIndex = index;
      _keywordPosition = iconOffset;
    });
  }

  void resetHighlightedIndex() {
    setState(() {
      _highlightedIndex = null;
    });
  }
}