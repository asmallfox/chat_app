import 'package:chat_app/src/widgets/communicate_icon_button.dart';
import 'package:chat_app/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'dart:ui' as ui;

class ChatVideoPage extends StatefulWidget {
  final Map friend;
  const ChatVideoPage({
    super.key,
    required this.friend,
  });
  @override
  State<ChatVideoPage> createState() => _ChatAudioPageState();
}

class _ChatAudioPageState extends State<ChatVideoPage> {
  bool isOnCall = false;
  bool isMuted = false;
  bool isOpenCamera = true;

  final RTCVideoRenderer localRenderer = RTCVideoRenderer();

  void init() async {
    await localRenderer.initialize();
  }

  void _call() async {
    localRenderer.srcObject = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {
        'width': MediaQuery.of(context).size.width,
        'height': MediaQuery.of(context).size.height,
      }
    });

    print('开始视频');
    setState(() {
      isOnCall = true;
    });
  }

  void _end() async {
    localRenderer.srcObject!.getTracks().forEach((track) => track.stop());

    setState(() {
      isOnCall = false;
    });
  }

  void _handleOpenAndCloseCamera(bool open) async {
    if (open) {
      localRenderer.srcObject = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': {
          'width': MediaQuery.of(context).size.width,
          'height': MediaQuery.of(context).size.height,
        }
      });
    } else {
      localRenderer.srcObject!.getTracks().forEach((track) => track.stop());
    }
    setState(() {
      isOpenCamera = open;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    localRenderer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            widget.friend['avatar'],
            fit: BoxFit.cover,
          ),
        ),
        // 模糊效果
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
        Visibility(
          visible: isOpenCamera,
          child: Positioned.fill(
            child: RTCVideoView(
              localRenderer,
              mirror: true,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.zoom_in_map_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: !isOpenCamera,
                  child: Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.grey.shade500,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            widget.friend['avatar'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                isOnCall
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CommunicateIconButton(
                                label: '麦克风',
                                icon: isMuted
                                    ? Icons.mic_off_rounded
                                    : Icons.mic_rounded,
                                color: Colors.grey.shade200,
                                onTap: () {
                                  setState(() {
                                    isMuted = !isMuted;
                                  });
                                },
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 214, 213, 213),
                                ),
                              ),
                              CommunicateIconButton(
                                label: '摄像头',
                                icon: isOpenCamera
                                    ? Icons.videocam_sharp
                                    : Icons.videocam_off_rounded,
                                color: Colors.white,
                                onTap: () {
                                  _handleOpenAndCloseCamera(!isOpenCamera);
                                },
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 214, 213, 213),
                                ),
                              ),
                              CommunicateIconButton(
                                label: '切换语音通话',
                                icon: Icons.call_made_rounded,
                                color: Colors.grey.shade200,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 214, 213, 213),
                                ),
                                onTap: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          RoundedButton(
                            icon: Icons.call_end_rounded,
                            color: Colors.white,
                            backgroundColor: Colors.red,
                            onPressed: () {
                              _end();
                            },
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RoundedButton(
                            icon: Icons.call_end_rounded,
                            color: Colors.white,
                            backgroundColor: Colors.red,
                            onPressed: () {
                              _end();
                            },
                          ),
                          RoundedButton(
                            icon: Icons.videocam_sharp,
                            color: Colors.white,
                            backgroundColor: Colors.green,
                            onPressed: () {
                              _call();
                            },
                          ),
                        ],
                      ),
                const SizedBox(height: 60)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
