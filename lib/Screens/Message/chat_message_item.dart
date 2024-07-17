import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app/CustomWidget/audio_icon.dart';
import 'package:chat_app/CustomWidget/custom_image.dart';
import 'package:chat_app/Helpers/audio_serice.dart';
import 'package:chat_app/Helpers/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class ChatMessageItem extends StatefulWidget {
  final Map item;

  const ChatMessageItem({
    super.key,
    required this.item,
  });

  @override
  State<ChatMessageItem> createState() => _ChatMessageItemState();
}

class _ChatMessageItemState extends State<ChatMessageItem> {
  final Map userInfo = LocalStorage.getUserInfo();

  String audioLength = '';

  bool isPlayAudio = false;

  @override
  void initState() {
    super.initState();
    if (widget.item['type'] == 3) {
      _initializePlayer();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        // onLongPressStart: (details) {
        //   print(details.globalPosition);
        // },
        onLongPressStart: (details) {
          RenderObject contextInfo = context.findRenderObject() as RenderObject;

          Rect rect = contextInfo.paintBounds;
          print('长按 $rect');
          print('当前位置：${details.globalPosition}');

          print(contextInfo.paintBounds);

          showGeneralDialog(
            context: context,
            barrierLabel: '',
            barrierColor: Colors.black.withOpacity(0.0),
            pageBuilder: (context, _, __) {
              return GestureDetector(
                onTap: () {
                  print('点击');
                  Navigator.of(context).pop();
                },
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.transparent,
                    ),
                    Positioned(
                      left: details.globalPosition.dx,
                      top: details.globalPosition.dy,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFF1e1e1e),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconTheme(
                          data: const IconThemeData(
                            color: Colors.white,
                            size: 36.0,
                            weight: 0.5,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: const Text('确定删除？'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('取消'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('删除'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete_outline),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              IconButton(
                                onPressed: () {
                                  print('复制');
                                },
                                icon: const Icon(Icons.copy_rounded),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );

          // showMenu(
          //   context: context,
          //   position: RelativeRect.fromLTRB(details.globalPosition.dx, details.globalPosition.dy, details.globalPosition.dx, details.globalPosition.dy),
          //   items: <PopupMenuEntry>[
          //     PopupMenuItem(
          //       value: 1,
          //       onTap: () {
          //         print('删除');
          //       },
          //       child: Text('删除'),
          //     ),
          //   ],
          // );
        },
        child: _getMessageWidget(context),
      ),
    );
  }

  Future<void> _initializePlayer() async {
    try {
      AudioPlayer _audioPlayer = AudioPlayer();
      await _audioPlayer.setSourceUrl(widget.item['message']);

      final audioDuration = await _audioPlayer.getDuration();

      if (audioDuration != null) {
        setState(() {
          audioLength = getAudioLength(audioDuration);
        });
      }
    } catch (e) {
      print('Failed to initialize player: $e');
    }
  }

  Widget _getMessageWidget(BuildContext context) {
    bool isCurrentUser = widget.item['from'] == userInfo['id'];

    switch (widget.item['type']) {
      case 2:
        return FractionallySizedBox(
          widthFactor: 0.7,
          child: CustomImage(
            imageUrl: widget.item['message'],
            fit: BoxFit.fitHeight,
          ),
        );
      case 3:
        return GestureDetector(
          onTap: () {
            print('播放语音');

            if (RecordingManager.audioPlayer.isPlaying) {
              RecordingManager.audioPlayer.audioPlayerFinished(2);
              RecordingManager.audioPlayer.stopPlayer();
            }

            RecordingManager.audioPlayer.startPlayer(
              fromURI: widget.item['message'],
              codec: Codec.mp3,
              whenFinished: () {
                setState(() {
                  isPlayAudio = false;
                });
              },
            );

            setState(() {
              isPlayAudio = true;
            });
          },
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  spreadRadius: 14,
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              textDirection:
                  isCurrentUser ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Transform.scale(
                  scaleX: -1,
                  child: AudioIcon(
                    isPlay: isPlayAudio,
                  ),
                ),
                Text(
                  audioLength.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      case 4:
        return Text('视频占位');
      case 5:
        return Text('文件占位');
      default:
        // case 1:
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 15,
              ),
              constraints: const BoxConstraints(
                minHeight: 40,
              ),
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    spreadRadius: 14,
                    blurRadius: 20,
                    offset: const Offset(6, 8),
                  ),
                ],
              ),
              child: Text(
                widget.item['message'] ?? 'null',
                style: TextStyle(
                  fontSize: 18,
                  color: isCurrentUser ? Colors.white : Colors.black,
                ),
              ),
            ),
            Positioned(
              top: 15,
              left: isCurrentUser ? null : 0,
              right: isCurrentUser ? 0 : null,
              child: MessageTriangle(
                isStart: isCurrentUser,
                color: isCurrentUser
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
              ),
            ),
          ],
        );
    }
  }
}

class MessageTriangle extends StatelessWidget {
  final bool isStart;
  final Color color;

  const MessageTriangle({
    super.key,
    this.isStart = true,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          top: const BorderSide(
            color: Colors.transparent,
            width: 6,
          ),
          bottom: const BorderSide(
            color: Colors.transparent,
            width: 6,
          ),
          start: BorderSide(
            color: isStart ? color : Colors.transparent,
            width: 8,
          ),
          end: BorderSide(
            color: isStart ? Colors.transparent : color,
            width: 8,
          ),
        ),
      ),
    );
  }
}

String getAudioLength(Duration duration) {
  int inHours = duration.inHours;
  int inMinutes = duration.inMinutes;
  int inSeconds = duration.inSeconds;

  String str = '';

  if (inHours != 0) str += "$inHours'";
  if (inMinutes != 0) str += "$inMinutes\"";
  if (inSeconds != 0) str += "$inSeconds\"";

  return str;
}
