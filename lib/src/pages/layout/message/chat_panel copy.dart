import 'package:chat_app/CustomWidget/custom_icon_button.dart';
import 'package:chat_app/src/helpers/keyboard_observer.dart';
import 'package:flutter/material.dart';

class ChatPanel extends StatefulWidget {
  const ChatPanel({
    super.key,
  });

  @override
  State<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> {
  bool _showSendButton = false;
  bool _showPanel = false;

  final TextEditingController _messageController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    KeyBoardObserver.instance;
  }

  @override
  void dispose() {
    _messageController.dispose();
    focusNode.dispose();
    WidgetsBinding.instance.removeObserver(KeyBoardObserver.instance);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      constraints: const BoxConstraints(
        minHeight: 80,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
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
                  child: TapRegion(
                    groupId: 'group1',
                    onTapOutside: (e) {
                      focusNode.unfocus();
                    },
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
                        controller: _messageController,
                        focusNode: focusNode,
                        onChanged: (value) {
                          setState(() {
                            _showSendButton = value.isNotEmpty;
                          });
                        },
                      ),
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
                        onPressed: () {
                          focusNode.unfocus();
                          setState(() {
                            _showPanel = true;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
              ],
            ),
          ),
          TapRegion(
            onTapOutside: (e) {
              setState(() {
                _showPanel = false;
              });
            },
            child: AnimatedContainer(
              height:
                  _showPanel || focusNode.hasFocus
                      ? 320
                      : 0,
              duration: const Duration(milliseconds: 10),
              child: Visibility(
                visible: true,
                child: GridView.count(
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
