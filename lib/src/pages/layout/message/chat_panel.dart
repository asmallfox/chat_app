import 'package:chat_app/CustomWidget/custom_icon_button.dart';
import 'package:chat_app/src/constants/const_keys.dart';
import 'package:chat_app/src/helpers/keyboard_observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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
  bool _showVoice = false;

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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showVoice = true;
                    });
                  },
                  icon: const Icon(Icons.keyboard_voice_rounded),
                ),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: TapRegion(
                    groupId: ConstKeys.chatPanelKey,
                    onTapOutside: (e) {
                      // SystemChannels.textInput.invokeMethod('TextInput.hide');
                      focusNode.unfocus();
                    },
                    child: Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      // padding: const EdgeInsets.symmetric(vertical: 10),
                      constraints: const BoxConstraints(
                        minHeight: 50,
                      ),
                      child: _showVoice
                          ? TextButton(
                              onPressed: () {},
                              onLongPress: () {},
                              style: ButtonStyle(
                              ),
                              child: const Text(
                                '按住 说话',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : TextField(
                              minLines: 1,
                              maxLines: 8,
                              focusNode: focusNode,
                              controller: _messageController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10)),
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
                TapRegion(
                  groupId: ConstKeys.chatPanelKey,
                  child: _showSendButton
                      ? FilledButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.zero,
                            ),
                          ),
                          child: const Text('发送'),
                        )
                      : IconButton(
                          onPressed: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            setState(() {
                              _showPanel = true;
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                )
                // _showSendButton
                //     ? TapRegion(
                //         groupId: ConstKeys.chatPanelKey,
                //         child: FilledButton(
                //           onPressed: () {},
                //           style: ButtonStyle(
                //             padding:
                //                 WidgetStateProperty.all<EdgeInsetsGeometry>(
                //               EdgeInsets.zero,
                //             ),
                //           ),
                //           child: const Text('发送'),
                //         ),
                //       )
                //     : IconButton(
                //         onPressed: () {
                //           setState(() {
                //             _showPanel = true;
                //           //   // focusNode.unfocus();
                //           //   SystemChannels.textInput
                //           //       .invokeMethod('TextInput.hide');
                //           });
                //         },
                //         icon: const Icon(Icons.add),
                //       ),
              ],
            ),
          ),
          TapRegion(
            groupId: ConstKeys.chatPanelKey,
            onTapOutside: (e) {
              print('xxxxxxxxxxxxxxxxxxxxx');
              setState(() {
                _showPanel = false;
                print(_showPanel);
                print(focusNode.hasFocus);
              });
            },
            child: Visibility(
              visible: _showPanel || focusNode.hasFocus,
              child: Container(
                height: KeyBoardObserver.instance.keyboardHeight,
                child: Opacity(
                  opacity: _showPanel ? 1 : 0,
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
              // child: AnimatedContainer(
              //   height: focusNode.hasFocus
              //       ? KeyBoardObserver.instance.keyboardHeight
              //       : 0,
              //   duration: const Duration(milliseconds: 10),
              //   child: Visibility(
              //     visible: true,
              //     child: GridView.count(
              //       primary: false,
              //       padding: const EdgeInsets.all(20),
              //       crossAxisSpacing: 20,
              //       mainAxisSpacing: 20,
              //       crossAxisCount: 4,
              //       shrinkWrap: true,
              //       children: [
              //         CustomIconButton(
              //           icon: Icons.photo,
              //           color: Theme.of(context).colorScheme.primary,
              //           onPressed: () {
              //             print('图片');
              //             // _pickImage();
              //           },
              //         ),
              //         CustomIconButton(
              //           icon: Icons.camera_alt_outlined,
              //           color: Theme.of(context).colorScheme.primary,
              //           onPressed: () {
              //             print('照相');
              //             // _takePicture();
              //           },
              //         ),
              //         CustomIconButton(
              //           icon: Icons.phone,
              //           color: Theme.of(context).colorScheme.primary,
              //           onPressed: () {
              //             print('语音');
              //           },
              //         ),
              //         CustomIconButton(
              //           icon: Icons.videocam_sharp,
              //           color: Theme.of(context).colorScheme.primary,
              //           onPressed: () {
              //             print('视频');
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
            ),
          ),
        ],
      ),
    );
  }
}
