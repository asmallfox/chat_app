import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:chat_app/src/helpers/recording_helper.dart';
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
  String? audioLength;
  Duration? audioDuration;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    RecordingHelper.audioPlayer.stopPlayer();
    RecordingHelper.audioPlayer.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await RecordingHelper.audioPlayer.openPlayer();
        RecordingHelper.audioPlayer.startPlayer(
          fromURI: widget.msgItem['content'],
          codec: Codec.mp3,
          whenFinished: () {
            print('播放结束');
            setState(() {
              isPlaying = false;
            });
          },
        );
      },
      child: Container(
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
              audioLength ?? '',
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

  void _init() async {
    try {
      AudioPlayer audioPlayer = AudioPlayer();

      audioDuration = await audioPlayer.setUrl(widget.msgItem['content']);

      if (audioDuration != null) {
        setState(() {
          audioLength = _getAudioLength(audioDuration!);
        });
      }
    } catch (error) {
      print('[Error] $error');
    }
  }

  String _getAudioLength(Duration duration) {
    int inHours = duration.inHours;
    int inMinutes = duration.inMinutes;
    int inSeconds = duration.inSeconds + (duration.inMilliseconds > 0 ? 1 : 0);

    String str = '';

    if (inHours != 0) str += "$inHours'";
    if (inMinutes != 0) str += "$inMinutes\"";
    if (inSeconds != 0) str += "$inSeconds\"";

    return str;
  }
}
