import 'package:chat_app/src/helpers/recording_helper.dart';
import 'package:chat_app/src/theme/colors.dart';
import 'package:chat_app/src/utils/share.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:chat_app/src/pages/layout/message/widgets/audio_play_icon.dart';

class ContentItemAudio extends StatefulWidget {
  final Map msgItem;
  final bool isSelf;

  const ContentItemAudio({
    super.key,
    required this.msgItem,
    required this.isSelf,
  });

  @override
  State<ContentItemAudio> createState() => _ContentItemAudioState();
}

class _ContentItemAudioState extends State<ContentItemAudio> {
  String audioLength = '';
  Duration? audioDuration;
  bool isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _togglePlayPause();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        constraints: const BoxConstraints(
          minHeight: 60,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: widget.isSelf ? AppColors.primary : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: widget.isSelf ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Transform.scale(
              scaleX: widget.isSelf ? -1 : 1,
              child: AudioPlayIcon(
                isPlay: isPlaying,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              formattedDuration(widget.msgItem['duration'] ?? 0),
              style: TextStyle(
                fontSize: 18,
                color: widget.isSelf ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 处理音频播放
  void _togglePlayPause() async {
    if (RecordingHelper.audioPlayer.isPlaying && !isPlaying) {
      RecordingHelper.audioPlayer.audioPlayerFinished(2);
    }

    if (isPlaying) {
      RecordingHelper.audioPlayer.pausePlayer();
    } else {
      print(widget.msgItem['content']);
      await RecordingHelper.audioPlayer.startPlayer(
        fromURI: widget.msgItem['content'],
        whenFinished: () {
          setState(() {
            isPlaying = !isPlaying;
          });
        },
      );
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }
}
