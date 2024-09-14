import 'package:chat_app/CustomWidget/custom_icon_button.dart';
import 'package:flutter/material.dart';

class ChatPanel extends StatefulWidget {
  const ChatPanel({
    super.key,
  });

  @override
  State<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> {
  bool _isInput = false;
  bool _showSendButton = false;

  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      constraints: const BoxConstraints(
        minHeight: 80,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.keyboard_voice_rounded),
              ),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  constraints: const BoxConstraints(
                    minHeight: 50,
                  ),
                  child: TextField(
                    minLines: 1,
                    maxLines: 8,
                    decoration: null,
                    onChanged: (value) {
                      setState(() {
                        _showSendButton = value.isNotEmpty;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              _showSendButton
                  ? FilledButton(
                      onPressed: () {},
                      child: Text('发送'),
                    )
                  : IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                    ),
            ],
          ),
          // AnimatedContainer(
          //   duration: const Duration(milliseconds: 100),
          //   child: ,
          // ),
          GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            crossAxisCount: 4,
            shrinkWrap: true,
            children: [
              CustomIconButton(
                icon: Icons.photo,
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  print('图片');
                  // _pickImage();
                },
              ),
              CustomIconButton(
                icon: Icons.camera_alt_outlined,
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  print('照相');
                  // _takePicture();
                },
              ),
              CustomIconButton(
                icon: Icons.phone,
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  print('语音');
                },
              ),
              CustomIconButton(
                icon: Icons.videocam_sharp,
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  print('视频');
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
