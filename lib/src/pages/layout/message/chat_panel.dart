import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_app/CustomWidget/custom_icon_button.dart';
import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/constants/const_keys.dart';
import 'package:chat_app/src/helpers/keyboard_observer.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/utils/message_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ChatPanel extends StatefulWidget {
  final Map item;
  final void Function(TapDownDetails)? onTapDown;
  final void Function(TapUpDetails)? onTapUp;
  final VoidCallback? onLongPress;
  final VoidCallback? onLongPressUp;
  final VoidCallback? onLongPressCancel;
  final void Function(LongPressMoveUpdateDetails)? onLongPressMoveUpdate;
  final void Function(LongPressDownDetails)? onLongPressDown;
  final void Function(LongPressStartDetails)? onLongPressStart;
  final void Function(DragUpdateDetails)? onHorizontalDragUpdate;
  final void Function(DragDownDetails)? onPanDown;
  final void Function(DragStartDetails)? onPanStart;
  final void Function(DragEndDetails)? onPanEnd;
  final void Function(DragUpdateDetails)? onPanUpdate;
  const ChatPanel({
    super.key,
    required this.item,
    this.onTapDown,
    this.onTapUp,
    this.onLongPress,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
    this.onLongPressDown,
    this.onLongPressStart,
    this.onLongPressCancel,
    this.onHorizontalDragUpdate,
    this.onPanDown,
    this.onPanStart,
    this.onPanEnd,
    this.onPanUpdate,
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
                          ? GestureDetector(
                              onTapDown: widget.onTapDown,
                              onTapUp: widget.onTapUp,
                              onLongPress: widget.onLongPress,
                              onLongPressDown: widget.onLongPressDown,
                              onLongPressStart: widget.onLongPressStart,
                              onLongPressMoveUpdate:
                                  widget.onLongPressMoveUpdate,
                              onLongPressUp: widget.onLongPressUp,
                              onLongPressCancel: widget.onLongPressCancel,
                              onHorizontalDragUpdate:
                                  widget.onHorizontalDragUpdate,
                              onPanDown: widget.onPanDown,
                              onPanStart: widget.onPanStart,
                              onPanEnd: widget.onPanEnd,
                              onPanUpdate: widget.onPanUpdate,
                              child: Container(
                                height: 50,
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: const Text('按住 说话'),
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
                                  left: 10,
                                  bottom: 10,
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
                          onPressed: _sendMessage,
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
                height: 0,
                // height: KeyBoardObserver.instance.keyboardHeight == 0
                //     ? null
                //     : KeyBoardObserver.instance.keyboardHeight,
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
                          // print('图片');
                          _pickImage();
                        },
                      ),
                      CustomIconButton(
                        icon: Icons.camera_alt_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          // print('照相');
                          _takePicture();
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

  Future<void> _sendMessage() async {
    // 发送消息
    print('发送消息：${_messageController.text}');

    Map msgData = {
      'type': MessageType.text.value,
      'content': _messageController.text,
      'from': UserHive.userInfo['account'],
      'to': widget.item['account'],
      'sendTime': DateTime.now().millisecondsSinceEpoch
    };

    final List friends = UserHive.userInfo['friends'];

    final friend = friends
        .firstWhere((element) => element['account'] == widget.item['account']);

    if (friend != null) {
      if (friend['messages'] == null) {
        friend['messages'] = [msgData];
      } else {
        friend['messages'].add(msgData);
      }

      // friend['messages'] = [];
    }

    setState(() {
      _messageController.clear();
      _showSendButton = false;
    });

    UserHive.box.put('friends', friends);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print(pickedFile.path);
      // Directory appDocDir = await getApplicationDocumentsDirectory();
      // String appDocPath = appDocDir.path;
      // // 生成一个唯一的文件名
      // String filePath =
      //     '$appDocPath/local-${DateTime.now().millisecondsSinceEpoch}.aac';

      // File file = File(filePath);

      // File audioFile = File(path);
      // await file.writeAsBytes(audioFile.readAsBytesSync());
      Map msgData = {
        'type': MessageType.image.value,
        'content': pickedFile.path,
        'from': UserHive.userInfo['account'],
        'to': widget.item['account'],
        'sendTime': DateTime.now().millisecondsSinceEpoch,
      };

      MessageUtil.add(widget.item['account'], msgData);
    }
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      print('相机拍照：${pickedFile.path}');
      // File imageFile = File(pickedFile.path);
      // List<int> imageBytes = imageFile.readAsBytesSync();
      // String base64Image = base64Encode(imageBytes);
      Map msgData = {
        'type': MessageType.image.value,
        'content': pickedFile.path,
        'from': UserHive.userInfo['account'],
        'to': widget.item['account'],
        'sendTime': DateTime.now().millisecondsSinceEpoch,
      };

      MessageUtil.add(widget.item['account'], msgData);
    }
  }
}
