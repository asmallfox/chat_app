import 'package:chat_app/CustomWidget/back_icon_button.dart';
import 'package:chat_app/src/constants/global_key.dart';
import 'package:chat_app/src/helpers/permissions_helper.dart';
import 'package:chat_app/src/helpers/recording_helper.dart';
import 'package:chat_app/src/pages/layout/message/chat_content.dart';
import 'package:chat_app/src/pages/layout/message/chat_panel.dart';
import 'package:chat_app/src/pages/layout/message/recording_panel.dart';
import 'package:chat_app/src/widgets/key_board_container.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final Map item;
  const ChatPage({
    super.key,
    required this.item,
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
                title: Text(widget.item['name']),
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
                  Expanded(
                    child: ChatContent(item: widget.item),
                  ),
                  ChatPanel(
                    item: widget.item,
                    onLongPressDown: (detail) {
                      _showRecordingPanel(detail);
                      _startRecording();
                    },
                    onPanStart: _showRecordingPanel,
                    onTapDown: _showRecordingPanel,
                    onPanUpdate: _handleCoincide,
                    onLongPressMoveUpdate: _handleCoincide,
                    onPanEnd: _cancelRecording,
                    onTapUp: _cancelRecording,
                    onLongPressUp: _cancelRecording,
                    onLongPressCancel: _cancelRecording,
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

  void _showRecordingPanel(dynamic detail) {
    setState(() {
      _testShow = true;
    });
    _handleCoincide(detail);
  }

  void _cancelRecording([dynamic detail]) {
    setState(() {
      _testShow = false;
      _closeButtonCoincide = false;
      _sendButtonCoincide = false;
    });
    _endRecording();
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

  Future<void> _startRecording() async {
    try {
      print('开始语音录制');
      await PermissionsHelper.microphone();
      await RecordingHelper.startRecording();
    } catch (error) {
      print('获取��克风权限失败：$error');
    }
  }

  Future<void> _endRecording() async {
    String? path = await RecordingHelper.stopRecording();
    if (path != null) {
      print(path);
    } else {
      print('结束语音录制，未能获取到语音路径');
    }
  }
}
