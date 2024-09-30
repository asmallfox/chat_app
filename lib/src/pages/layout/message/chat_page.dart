import 'package:chat_app/CustomWidget/back_icon_button.dart';
import 'package:chat_app/src/constants/global_key.dart';
import 'package:chat_app/src/pages/layout/message/chat_content.dart';
import 'package:chat_app/src/pages/layout/message/chat_panel.dart';
import 'package:chat_app/src/pages/layout/message/recording_panel.dart';
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
  bool _closeButtonCoincide = false;
  bool _sendButtonCoincide = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: KeyboardContainer(
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
                  ChatPanel(
                    onPanStart: (detail) {
                      setState(() {
                        _testShow = true;
                      });
                      _handleCoincide(detail);
                    },
                    onPanEnd: (detail) {
                      setState(() {
                        _testShow = false;
                        _closeButtonCoincide = false;
                        _sendButtonCoincide = false;
                      });
                    },
                    onPanUpdate: _handleCoincide,
                    onTapDown: (detail) {
                      setState(() {
                        _testShow = true;
                      });
                      _handleCoincide(detail);
                    },
                    onTapUp: (detail) {
                      setState(() {
                        _testShow = false;
                        _closeButtonCoincide = false;
                        _sendButtonCoincide = false;
                      });
                    },
                    onLongPressDown: (detail) {
                      setState(() {
                        _testShow = true;
                      });
                      _handleCoincide(detail);
                    },
                    onLongPressMoveUpdate: _handleCoincide,
                    onLongPressUp: () {
                      setState(() {
                        _testShow = false;
                        _closeButtonCoincide = false;
                        _sendButtonCoincide = false;
                      });
                    },
                    onLongPressCancel: () {
                      setState(() {
                        _testShow = false;
                        _closeButtonCoincide = false;
                        _sendButtonCoincide = false;
                      });
                    },
                  ),
                ],
              ),
              resizeToAvoidBottomInset: false, // 页面是否被软键盘顶起
            ),
            Visibility(
              visible: _testShow,
              child: Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: RecordingPanel(
                    closeButtonCoincide: _closeButtonCoincide,
                    sendButtonCoincide: _sendButtonCoincide,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCoincide(dynamic detail) {
    final voiceSendBtn =
        _widgetCoincide(voiceSendKey, detail.globalPosition, 1);

    final voiceCloseBtn =
        _widgetCoincide(voiceCancelKey, detail.globalPosition, 2);

    if (_closeButtonCoincide != voiceCloseBtn) {
      setState(() {
        _closeButtonCoincide = voiceCloseBtn;
      });
    }
    if (_sendButtonCoincide != voiceSendBtn) {
      setState(() {
        _sendButtonCoincide = voiceSendBtn;
      });
    }
  }

  bool _widgetCoincide(GlobalKey widgetKey, Offset position, int type) {
    if (widgetKey.currentContext == null) return type == 1;

    RenderBox renderBox =
        widgetKey.currentContext?.findRenderObject() as RenderBox;

    Offset offset = renderBox.localToGlobal(Offset.zero);
    double boxX = offset.dx;
    double boxY = offset.dy;
    double x = position.dx;
    double y = position.dy;
    double sizeW = renderBox.size.width;
    double sizeH = renderBox.size.height;

    bool coincide =
        (x > boxX && x < boxX + sizeW) && (y > boxY && y < boxY + sizeH);
    // if (type == 2) {
    //   print('===== x = $x, y = $y, sizeW = $sizeW');
    //   print('===== boxX = $boxX, boxY = $boxY, sizeH = $sizeH');
    // }
    return coincide;
  }
}
