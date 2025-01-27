import 'package:chat_app/src/helpers/recording_helper.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:chat_app/src/widgets/communicate_icon_button.dart';
import 'package:chat_app/src/widgets/picture.dart';
import 'package:chat_app/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ChatsAudioPage extends StatefulWidget {
  final Map friend;

  const ChatsAudioPage({
    super.key,
    required this.friend,
  });

  @override
  State<ChatsAudioPage> createState() => _ChatsAudioPageState();
}

class _ChatsAudioPageState extends State<ChatsAudioPage> {
  // 正在通话
  bool isOnCall = false;
  // 扩音
  bool isExpanded = false;
  // 静音
  bool isMuted = false;

  void _init() {
    RecordingHelper.play('assets/mp3/chat_notice.mp3', assets: true);
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Picture(
            url: widget.friend['avatar'],
            fit: BoxFit.fill,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.68),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 32, sigmaY: 32),
            child: const SizedBox(),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.close_fullscreen_rounded),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              widget.friend['name'],
              style: const TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.grey.shade500,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Avatar(
                      url: widget.friend['avatar'],
                      isCircle: true,
                    )),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 免提
                    Visibility(
                      visible: isOnCall,
                      child: CommunicateIconButton(
                        color: Colors.grey.shade300,
                        icon: Icons.volume_off_rounded,
                        onTap: () {},
                      ),
                    ),
                    RoundedButton(
                      icon: Icons.call_end_rounded,
                      color: Colors.white,
                      backgroundColor: Colors.red,
                      onPressed: () {
                        setState(() {
                          isOnCall = false;
                        });
                        // Navigator.of(context).pop();
                      },
                    ),
                    Visibility(
                      visible: !isOnCall,
                      child: RoundedButton(
                        icon: Icons.local_phone_rounded,
                        color: Colors.white,
                        backgroundColor: Colors.green,
                        onPressed: () {
                          setState(() {
                            isOnCall = true;
                          });
                        },
                      ),
                    ),
                    // 静音
                    Visibility(
                      visible: isOnCall,
                      child: CommunicateIconButton(
                        color: Colors.grey.shade300,
                        icon: isMuted
                            ? Icons.mic_external_off_rounded
                            : Icons.mic_none_rounded,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
