import 'package:chat_app/CustomWidget/avatar.dart';
import 'package:chat_app/CustomWidget/back_icon_button.dart';
import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/socket/socket_io.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_webrtc/flutter_webrtc.dart';

class ChatAudioPage extends StatefulWidget {
  final Map chatItem;

  const ChatAudioPage({
    super.key,
    required this.chatItem,
  });

  @override
  State<ChatAudioPage> createState() => _ChatAudioPageState();
}

class _ChatAudioPageState extends State<ChatAudioPage> {
  bool openSpeaker = false;
  bool openMic = true;

  late final user = LocalStorage.getUserInfo();

  late RTCPeerConnection _peerConnection;
  late MediaStream _localStream;
  late MediaStream _remoteStream;

  @override
  void initState() {
    super.initState();
    initWebRTC();
  }

  void initWebRTC() async {
    // 初始化 PeerConnection configuration
    _peerConnection = await createPeerConnection({});
    // 获取本地媒体流
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });

    // 添加本地媒体流到 PeerConnection
    _localStream.getTracks().forEach((track) {
      _peerConnection.addTrack(track, _localStream);
    });

    // 设置远端流监听器
    _peerConnection.onTrack = (event) {
      if (event.track.kind == 'audio') {
        setState(() {
          _remoteStream = event.streams[0];
        });
      }
    };

    _peerConnection.onConnectionState = (state) {
      print('connectionState $state');
    };

    // 创建 Offer
    RTCSessionDescription offer = await _peerConnection.createOffer({});
    await _peerConnection.setLocalDescription(offer);

    // 通知另一客户端
    SocketIOClient.emitWithAck(
      'offer',
      {
        'from': user['id'],
        'to': widget.chatItem['friendId'] ?? widget.chatItem['id'],
        'offer': offer,
        'type': 3,
      },
      ack: (res) {
        print(res);
      },
    );
  }


  @override
  void dispose() {
    super.dispose();
    _localStream?.dispose();
    _remoteStream?.dispose();
    _peerConnection?.close();
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
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: BackIconButton(
              color: Colors.white,
              backFn: () {
                // Provider.of<ChatModel>(context, listen: false).removeChat();
              },
            ),
            title: const Text(
              '呼叫中...',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      // margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.grey.shade500,
                          ),
                          borderRadius: BorderRadius.circular(100)),
                      child: Avatar(
                        imageUrl: widget.chatItem['avatar'],
                        size: 100,
                        rounded: true,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      widget.chatItem['nickname'],
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.red)),
                          child: const Text(
                            '挂断',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.green)),
                          child: const Text(
                            '接听',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
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
