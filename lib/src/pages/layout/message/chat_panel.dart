import 'package:chat_app/CustomWidget/custom_icon_button.dart';
import 'package:chat_app/src/constants/const_keys.dart';
import 'package:chat_app/src/helpers/keyboard_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  bool _showVoiceButton = false;

  final TextEditingController _messageController = TextEditingController();
  final FocusNode focusNode = FocusNode();

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
                      _showVoiceButton = !_showVoiceButton;
                    });
                  },
                  icon: Icon(_showVoiceButton
                      ? Icons.keyboard_alt_outlined
                      : Icons.keyboard_voice_rounded),
                ),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: TapRegion(
                    groupId: ConstKeys.chatPanelKey,
                    onTapOutside: (e) {
                      focusNode.unfocus();
                    },
                    child: Container(
                      color: Colors.white,
                      constraints: const BoxConstraints(
                        minHeight: 50,
                      ),
                      child: _showVoiceButton
                          ? SizedBox(
                              height: 50,
                              child: TextButton(
                                onPressed: () {},
                                onLongPress: () {
                                  showVoicePanel(context);
                                },
                                style: ButtonStyle(
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  '按住 说话',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
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
                                  top: 10,
                                  bottom: 10,
                                  left: 10,
                                ),
                              ),
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
              ],
            ),
          ),
          TapRegion(
            groupId: ConstKeys.chatPanelKey,
            onTapOutside: (e) {
              setState(() {
                _showPanel = false;
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
            ),
          ),
        ],
      ),
    );
  }

  void showVoicePanel(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final voiceCancelKey = GlobalKey();
    final voiceSendKey = GlobalKey();
    bool closeButtonCoincide = false;
    bool sendButtonCoincide = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Listener(
          onPointerUp: (event) {
            if (closeButtonCoincide || sendButtonCoincide) {
              Navigator.of(context).pop();
            }
            setState(() {
              closeButtonCoincide = false;
              sendButtonCoincide = false;
            });
          },
          onPointerMove: (detail) {
            bool closeBtnCde = widgetCoincide(voiceCancelKey, detail.position);
            bool sendBtnCde = widgetCoincide(voiceSendKey, detail.position);

            if (closeButtonCoincide != closeBtnCde) {
              setState(() {
                closeButtonCoincide = closeBtnCde;
              });
              if (closeBtnCde) {
                print('取消语音');
              }
            }
            if (sendButtonCoincide != sendBtnCde) {
              setState(() {
                sendButtonCoincide = sendBtnCde;
              });
              if (sendBtnCde) {
                print('发送语音');
              }
            }
          },
          child: Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        key: voiceCancelKey,
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: closeButtonCoincide
                              ? Colors.black26
                              : Colors.black38,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: closeButtonCoincide
                              ? Colors.grey[100]
                              : Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: width,
                  height: 100,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: -(width * 0.5 / 2),
                        child: ClipOval(
                          child: Container(
                            key: voiceSendKey,
                            width: width * 1.5,
                            height: 400,
                            color: sendButtonCoincide
                                ? Colors.black26
                                : Colors.black38,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool widgetCoincide(GlobalKey widgetKey, Offset position) {
    RenderBox renderBox =
        widgetKey.currentContext?.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    double boxX = offset.dx;
    double boxY = offset.dy;
    double x = position.dx;
    double y = position.dy;
    double size = renderBox.size.width;

    bool coincide =
        (x > boxX && x < boxX + size) && (y > boxY && y < boxY + size);

    return coincide;
  }
}