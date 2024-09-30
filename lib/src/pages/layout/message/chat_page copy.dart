import 'package:chat_app/CustomWidget/back_icon_button.dart';
import 'package:chat_app/src/pages/layout/message/chat_content.dart';
import 'package:chat_app/src/pages/layout/message/chat_panel.dart';
import 'package:chat_app/src/widgets/key_board_container.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _testShow = false;

  @override
  Widget build(BuildContext context) {
    return KeyboardContainer(
        child: Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: BackIconButton(
              backFn: () {},
            ),
            title: const Text('谁在聊天...'),
            actions: [
              IconButton(
                onPressed: () async {
                  print('语音');
                },
                icon: const Icon(Icons.phone),
                color: Theme.of(context).colorScheme.primary,
              ),
              IconButton(
                onPressed: () {
                  print('视频');
                },
                icon: const Icon(Icons.videocam_sharp),
                color: Theme.of(context).colorScheme.primary,
              ),
              IconButton(
                onPressed: () {
                  print('更多');
                },
                icon: const Icon(Icons.more_vert_rounded),
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          body: Column(
            children: [
              const Expanded(
                child: ChatContent(),
              ),
              const ChatPanel(),
              GestureDetector(
                onLongPressEnd: (details) {
                  print('onLongPressEnd 中断长按事件');
                },
                onLongPress: () {
                  print('长按事件');
                  setState(() {
                    _testShow = true;
                  });
                },
                child: SizedBox(
                  height: 50,
                  child: Text('按钮'),
                ),
              )
            ],
          ),
          resizeToAvoidBottomInset: false, // 页面是否被软键盘顶起
        ),
        Visibility(
          visible: _testShow,
          child: Positioned.fill(
            child: Listener(
              onPointerUp: (event) {
                print('鼠标松开');
                setState(() {
                  _testShow = false;
                });
              },
              onPointerMove: (event) {
                print('鼠标移动');
              },
              child: Container(
                width: 200,
                height: 200,
                color: Colors.black.withOpacity(0.5),
                child: const Text('弹窗测试'),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
