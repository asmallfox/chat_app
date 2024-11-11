import 'package:chat_app/src/widgets/communicate_icon_button.dart';
import 'package:chat_app/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

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

  final RTCVideoRenderer localRenderer = RTCVideoRenderer();

  void init() async {
    await localRenderer.initialize();
  }

  void _call() async {
    localRenderer.srcObject = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {
        'width': 100,
        'height': 100,
      }
    });

    print('开始视频');
    setState(() {});
  }

  void _end() async {
    localRenderer.srcObject!.getTracks().forEach((track) => track.stop());
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
        Positioned(
          child: Text('xxxxxxx'),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            // backgroundColor: Colors.transparent,
            title: Text(
              widget.friend['name'],
              style: const TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                color: Colors.pink,
                child: RTCVideoView(
                  localRenderer,
                  mirror: true,
                ),
              ),
              Row(
                children: [
                  RoundedButton(
                    icon: Icons.local_phone_rounded,
                    color: Colors.white,
                    backgroundColor: Colors.red,
                    onPressed: () {
                      // setState(() {
                      //   isOnCall = false;
                      // });
                      _end();
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
                        _call();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
