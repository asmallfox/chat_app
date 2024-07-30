import 'dart:async';

import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/back_icon_button.dart';
import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/provider/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class ChatAudioPage extends StatefulWidget {
  const ChatAudioPage({
    super.key,
  });

  @override
  State<ChatAudioPage> createState() => _ChatAudioPageState();
}

class _ChatAudioPageState extends State<ChatAudioPage> {
  late Map<dynamic, dynamic>? currentChat =
      Provider.of<ChatModelProvider?>(context)?.communicate;

  late final user = LocalStorage.getUserInfo();

  bool openSpeaker = false;
  bool openMic = true;

  RTCVideoRenderer localRenderer = RTCVideoRenderer();

  void backFn() {
    Timer(const Duration(milliseconds: 300), () {
      Navigator.pop(context);
    });
  }

  @override
  void initState()  {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    localRenderer.dispose();
  }

  void init() async {
    await localRenderer.initialize();
    localRenderer.srcObject = context.read<ChatModelProvider>().localStream;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 模糊效果
        Positioned.fill(
          child: Image.asset(
            'assets/images/default_avatar.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: const SizedBox(),
          ),
        ),
        // 中心的图像
        Consumer<ChatModelProvider>(
          builder: (context, model, _) {
            ChatModelProvider chatModel = context.read<ChatModelProvider>();
            Map? communicate = context.watch<ChatModelProvider>().communicate;

            // 呼叫
            bool isInCall =
                communicate?['offer'] == null && communicate?['answer'] == null;
            // 来电
            bool isIncomingClass =
                communicate?['offer'] != null && !chatModel.isCommunicate;

            if (communicate == null) {
              backFn();
            }

            String title = chatModel.isCommunicate
                ? '已接通'
                : isInCall
                    ? '呼叫中...'
                    : '';

            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: const BackIconButton(
                  color: Colors.white,
                ),
                title: Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Visibility(
                          visible: chatModel.localStream != null,
                          child: RTCVideoView(
                            chatModel.localRenderer,
                            mirror: true,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.grey.shade500,
                              ),
                              borderRadius: BorderRadius.circular(100)),
                          child: Avatar(
                            imageUrl: currentChat?['avatar'] ?? '',
                            size: 100,
                            rounded: true,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          currentChat?['nickname'] ?? '',
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 100,
                          child: RTCVideoView(localRenderer),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CommunicateIcon(
                              label: '免提',
                              color: Colors.grey.shade400,
                              icon: openSpeaker
                                  ? Icons.volume_up
                                  : Icons.volume_off_rounded,
                              onTap: () {
                                setState(() {
                                  openSpeaker = !openSpeaker;
                                });
                              },
                            ),
                            CommunicateIcon(
                              label: '麦克风',
                              color: Colors.grey.shade400,
                              icon: openMic
                                  ? Icons.mic_none_rounded
                                  : Icons.mic_off_sharp,
                              onTap: () {
                                setState(() {
                                  openMic = !openMic;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilledButton(
                              onPressed: () async {
                                chatModel.stopPeerConnection();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.red),
                              ),
                              child: Text(
                                communicate == null
                                    ? '通话结束'
                                    : isIncomingClass
                                        ? '拒绝'
                                        : '挂断',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: isIncomingClass ? 50 : 0,
                            ),
                            Visibility(
                              visible: isIncomingClass,
                              child: FilledButton(
                                onPressed: () {
                                  chatModel.putThrough();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.green),
                                ),
                                child: const Text(
                                  '接听',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CommunicateIcon extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color color;
  final VoidCallback? onTap;

  const CommunicateIcon({
    super.key,
    required this.icon,
    this.label,
    this.color = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: color,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              size: 40,
              color: color,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: label != null,
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 24,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
