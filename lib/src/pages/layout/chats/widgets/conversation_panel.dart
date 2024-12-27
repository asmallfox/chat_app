import 'package:chat_app/CustomWidget/custom_icon_button.dart';
import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/constants/const_keys.dart';
import 'package:chat_app/src/helpers/keyboard_observer.dart';
import 'package:chat_app/src/pages/layout/chats/widgets/panel_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ConversationPanel extends StatefulWidget {
  final void Function(Map)? onSend;
  const ConversationPanel({
    super.key,
    this.onSend,
  });

  @override
  State<ConversationPanel> createState() => _ConversationPanelState();
}

class _ConversationPanelState extends State<ConversationPanel> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  bool _inputBtn = true;
  bool _showSendBtn = false;
  bool _showFnPanel = false;

  @override
  void dispose() {
    focusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(
        minHeight: 80,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _inputBtn = !_inputBtn;
                    });
                  },
                  icon: Icon(_inputBtn
                      ? Icons.keyboard_alt_outlined
                      : Icons.keyboard_voice_rounded),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: TapRegion(
                    groupId: ConstKeys.chatPanelKey,
                    child: Container(
                      color: Colors.white,
                      constraints: const BoxConstraints(
                        minHeight: 50,
                      ),
                      child: _inputBtn
                          ? TextField(
                              minLines: 1,
                              maxLines: 8,
                              focusNode: focusNode,
                              controller: _messageController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                  bottom: 10,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _showSendBtn = value.isNotEmpty;
                                });
                              },
                            )
                          : PanelAudio(
                              onSend: _sendMessage,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                TapRegion(
                  groupId: ConstKeys.chatPanelKey,
                  child: _showSendBtn
                      ? Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: FilledButton(
                            onPressed: _sendMessage,
                            style: ButtonStyle(
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.zero,
                              ),
                            ),
                            child: const Text('发送'),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            setState(() {
                              _showFnPanel = true;
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                ),
              ],
            ),
          ),
          TapRegion(
            groupId: ConstKeys.chatPanelKey,
            onTapOutside: (e) {
              setState(() {
                _showFnPanel = false;
              });
            },
            child: Visibility(
              visible: _showFnPanel || focusNode.hasFocus,
              child: SizedBox(
                height: KeyBoardObserver.instance.keyboardHeight == 0
                    ? null
                    : KeyBoardObserver.instance.keyboardHeight,
                child: Opacity(
                  opacity: _showFnPanel ? 1 : 0,
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    children: [
                      // 图片
                      CustomIconButton(
                        icon: Icons.photo,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                      // 拍照
                      CustomIconButton(
                        icon: Icons.camera_alt_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () => _pickImage(ImageSource.camera),
                      ),
                      CustomIconButton(
                        icon: Icons.phone,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          print('语音');
                        },
                      ),
                      // 视频
                      CustomIconButton(
                        icon: Icons.videocam_sharp,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage([Map? data]) async {
    if (_inputBtn) {
      widget.onSend?.call({
        'content': _messageController.text,
        'type': MessageType.text.value,
      });
      setState(() {
        _messageController.clear();
        _showSendBtn = false;
      });
    } else if (data?['filePath'] != null) {
      widget.onSend?.call({
        'type': MessageType.audio.value,
        'content': data?['filePath'],
        'duration': data?['duration'],
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      widget.onSend?.call({
        'content': pickedFile.path,
        'type': MessageType.image.value,
      });
    }
  }
}
