import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app/CustomWidget/audio_icon.dart';
import 'package:chat_app/Helpers/audio_service.dart';
import 'package:chat_app/Helpers/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class MessageAudio extends StatefulWidget {
  final Map item;

  const MessageAudio({
    super.key,
    required this.item,
  });

  @override
  State<MessageAudio> createState() => _MessageAudioState();
}

class _MessageAudioState extends State<MessageAudio> {
  Map userInfo = LocalStorage.getUserInfo();
  String? audioLength;
  Duration? audioDuration;

  bool isPlaying = false;
  bool isSelf = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    try {
      isSelf = userInfo['id'] == widget.item['from'];

      AudioPlayer _audioPlayer = AudioPlayer();

      await _audioPlayer.setSourceUrl(widget.item['message']);

      audioDuration = await _audioPlayer.getDuration();
      if (audioDuration != null) {
        setState(() {
          audioLength = _getAudioLength(audioDuration!);
        });
      }
    } catch (error) {
      print('[Error] $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print('播放语音');
        print(widget.item['message']);
        // if (RecordingManager.audioPlayer.isPlaying) {
        //   RecordingManager.audioPlayer.audioPlayerFinished(2);
        //   RecordingManager.audioPlayer.stopPlayer();
        // }

        String? url = widget.item['message'];

        if (url != null) {
          AudioPlayer _audioPlayer = AudioPlayer();

          _audioPlayer.onPlayerComplete.listen((event) {
            print('播放结束');
            setState(() {
              isPlaying = false;
            });
          });

          _audioPlayer.play(UrlSource(url));
        }

        setState(() {
          isPlaying = true;
        });
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        // width: (MediaQuery.of(context).size.width / 2 / 60) *
        //     audioDuration!.inSeconds ?? 0,
        // constraints: BoxConstraints(
        //   minWidth: 80,
        //   maxWidth: MediaQuery.of(context).size.width / 2,
        // ),
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
          mainAxisSize: MainAxisSize.min,
          textDirection: isSelf ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Transform.scale(
              scaleX: isSelf ? -1 : 1,
              child: AudioIcon(
                isPlay: isPlaying,
              ),
            ),
            Text(
              audioLength ?? '',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}

String _getAudioLength(Duration duration) {
  int inHours = duration.inHours;
  int inMinutes = duration.inMinutes;
  int inSeconds = duration.inSeconds;

  String str = '';

  if (inHours != 0) str += "$inHours'";
  if (inMinutes != 0) str += "$inMinutes\"";
  if (inSeconds != 0) str += "$inSeconds\"";

  return str;
}
