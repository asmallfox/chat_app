import 'dart:io';

import 'package:chat_app/CustomWidget/back_icon_button.dart';
import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/constants/global_key.dart';
import 'package:chat_app/src/helpers/permissions_helper.dart';
import 'package:chat_app/src/helpers/recording_helper.dart';
import 'package:chat_app/src/pages/layout/message/chat_audio_page.dart';
import 'package:chat_app/src/pages/layout/message/chat_content.dart';
import 'package:chat_app/src/pages/layout/message/chat_panel.dart';
import 'package:chat_app/src/pages/layout/message/recording_panel.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/widgets/key_board_container.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

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

  bool _isRecording = false;
  int _recordingStartTime = 0;
  int _recordingDuration = 0; // 录音时长

  final player = AudioPlayer();

  @override
  void dispose() {
    super.dispose();
    RecordingHelper.audioPlayer.stopPlayer();
    RecordingHelper.audioPlayer.closePlayer();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: KeyboardContainer(
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
              appBar: AppBar(
                leading: BackIconButton(
                  backFn: () {},
                ),
                title: Text(widget.item['name']),
                actions: [
                  IconButton(
                    onPressed: () async {
                      // print('语音');
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              ChatAudioPage(friend: widget.item),
                        ),
                      );
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
                  ChatContent(item: widget.item),
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
    if (_isRecording) return;
    try {
      print('开始语音录制');
      await PermissionsHelper.microphone();
      RecordingHelper.startRecording();
      _isRecording = true;
      _recordingStartTime = DateTime.now().millisecondsSinceEpoch;
    } catch (error) {
      print('获取麦克风权限失败：$error');
    }
  }

  Future<void> _endRecording() async {
    if (!_isRecording) return;
    try {
      String? path = await RecordingHelper.stopRecording();
      if (path != null) {
        _recordingDuration =
            (DateTime.now().millisecondsSinceEpoch - _recordingStartTime) ~/
                1000; // 计算录音时长（秒）

        if (_recordingDuration < 1) {
          const snackBar = SnackBar(
            content: Text('录音时长太短'),
            duration: Duration(seconds: 1),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          throw Exception('录音时长太短~');
        }

        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        // 生成一个唯一的文件名
        String filePath =
            '$appDocPath/local-${DateTime.now().millisecondsSinceEpoch}.aac';

        File file = File(filePath);

        File audioFile = File(path);

        await file.writeAsBytes(audioFile.readAsBytesSync());

        final duration = await player.setUrl(path);

        Map msgData = {
          'type': MessageType.voice.value,
          'content': filePath,
          'from': UserHive.userInfo['account'],
          'to': widget.item['account'],
          'file': audioFile.readAsBytesSync(),
          'duration': (duration!.inMilliseconds / 1000).ceil(),
          'sendTime': DateTime.now().millisecondsSinceEpoch,
        };

        final List friends = UserHive.userInfo['friends'];

        final friend = friends.firstWhere(
            (element) => element['account'] == widget.item['account']);

        if (friend != null) {
          if (friend['messages'] == null) {
            friend['messages'] = [msgData];
          } else {
            friend['messages'].add(msgData);
          }
        }

        UserHive.box.put('friends', friends);

        setState(() {
          _isRecording = false;
        });
      } else {
        print('结束语音录制，未能获取到语音路径');
      }
    } catch (error) {
      print('录音失败');
    }
  }
}
