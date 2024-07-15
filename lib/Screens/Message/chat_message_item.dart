import 'dart:math';

import 'package:chat_app/CustomWidget/audio_icon.dart';
import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/constants/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';

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

  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();

  Widget _getMessageWidget(BuildContext context) {
    bool isCurrentUser = widget.item['from'] == userInfo['id'];

    switch (widget.item['type']) {
      case 1:
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 10,
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
                widget.item['message'],
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
      case 2:
        return Avatar(
          imageUrl: widget.item['message'],
        );
      case 3:
        return GestureDetector(
          onTap: () {
            print('播放语音');
            _audioPlayer.startPlayer(
                fromURI: widget.item['message'], codec: Codec.mp3);
          },
          child: Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 15),
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
            child: AudioIcon(),
          ),
        );
      case 4:
        return Text('视频占位');
      case 5:
        return Text('文件占位');
    }

    return Text('xxx');
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer.openPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.closePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return _getMessageWidget(context);
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
