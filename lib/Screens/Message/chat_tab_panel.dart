import 'dart:convert';
import 'dart:io';

import 'package:chat_app/CustomWidget/custom_icon_button.dart';
import 'package:chat_app/Helpers/audio_serice.dart';
import 'package:chat_app/Helpers/show_tip_message.dart';
import 'package:chat_app/Helpers/system_utils.dart';
import 'package:chat_app/constants/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

final GlobalKey<_ChatTabPanelState> chatTabPanelKey = GlobalKey();

class ChatTabPanel extends StatefulWidget {
  final Function(Map)? onSend;

  const ChatTabPanel({
    super.key,
    this.onSend,
  });

  @override
  State<ChatTabPanel> createState() => _ChatTabPanelState();
}

class _ChatTabPanelState extends State<ChatTabPanel>
    with WidgetsBindingObserver {
  bool showSendButton = false;
  bool showPanel = false;
  bool isKeyboardVisible = false;
  bool isAudio = false;
  bool _isOverlyClose = false;
  late OverlayEntry _overlayEntry;

  bool showAudioPanel = false;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final GlobalKey audioCloseKey = GlobalKey();

  // final GlobalKey audioCloseKey = GlobalKey();

  // RecordingManager _recordingManager = RecordingManager();

  void onHiddenPanel() {
    setState(() {
      showPanel = false;
    });
  }

  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Widget _imagePreview() {
    return _imageFile == null
        ? Text('No image selected.')
        : Image.file(_imageFile!);
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // setState(() {
      //   _imageFile = File(pickedFile.path);
      // });
      _imageFile = File(pickedFile.path);

      print('相机拍照：${pickedFile.path}');
      print(pickedFile);

      if (widget.onSend != null) {
        List<int> imageBytes = _imageFile!.readAsBytesSync();
        // String base64Image = base64Encode(imageBytes);

        widget.onSend!({
          'content': pickedFile.path,
          'file': imageBytes,
          'type': messageType['image']?['value']
        });
      }
    }
  }

  void _showBottomSheet() {
    // Scaffold.of(context).showBottomSheet((context) {
    //   return SizedBox(
    //     height: 200,
    //     width: MediaQuery.of(context).size.width,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Container(
    //           key: audioCloseKey,
    //           padding: EdgeInsets.all(_isOverlyClose ? 10 : 8),
    //           decoration: BoxDecoration(
    //             color: _isOverlyClose ? Colors.red : Colors.pink,
    //             // color: _isOverlyClose
    //             //     ? Theme.of(context).colorScheme.primary
    //             //     : Theme.of(context).colorScheme.tertiary,
    //             borderRadius: BorderRadius.circular(50),
    //           ),
    //           child: const Icon(
    //             Icons.close_rounded,
    //             color: Colors.white,
    //           ),
    //         ),
    //         Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Icon(
    //               Icons.multitrack_audio,
    //               color: Theme.of(context).colorScheme.primary,
    //               size: 58,
    //             ),
    //             const Text('松开发送'),
    //           ],
    //         ),
    //         TextButton(
    //           onPressed: () {},
    //           onHover: (hover) {
    //             print('未实现');
    //           },
    //           child: const Icon(
    //             Icons.question_mark_rounded,
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // });
  }

  void _hideBottomSheet() {
    Navigator.pop(context);
    _isOverlyClose = false;
    print('录音完成');
  }

  void _handleAudio() {
    // 语音
    try {
      // await _recordingManager.startRecording();
      print('开始录音');
      _showBottomSheet();
    } catch (error) {
      print('录音错误: $error');
    }
  }

  void _handleOverlap(detail) {
    RenderBox renderBox =
        audioCloseKey.currentContext?.findRenderObject() as RenderBox;
    Offset acOffset = renderBox.localToGlobal(Offset.zero);
    double acX = acOffset.dx;
    double acY = acOffset.dy;
    double acW = renderBox.size.width;
    double acH = renderBox.size.height;

    double mouseX = detail.globalPosition.dx;
    double mouseY = detail.globalPosition.dy;

    // bool isOverlap = (mouseX >= acX && mouseX <= acX + acW) &&
    //     (mouseY > acY && mouseY < acY + acH);
    bool isOverlap = mouseX >= acX && mouseX <= acX + acW;

    setState(() {
      _isOverlyClose = isOverlap;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _overlayEntry = OverlayEntry(builder: (context) => Container());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // 如果MediaQuery.of(context).viewInsets.bottom获取键盘高度如果无论如何都是0，
    // 需设置父级Scaffold的resizeToAvoidBottomInset为false

    // final isKeyboardNowVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    // setState(() {
    //   isKeyboardVisible = isKeyboardNowVisible;
    //   if (isKeyboardNowVisible) {
    //     showPanel = false;
    //   } else {
    //   }
    // });

    // if (isKeyboardNowVisible) {
    //   setState(() {
    //     showPanel = false;
    //   });
    // }
    // print(MediaQuery.of(context).size.height);
    if (showPanel) {
      if (_focusNode.hasFocus) {
        setState(() {
          showPanel = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomIconButton(
                  icon: isAudio
                      ? Icons.keyboard_alt_outlined
                      : Icons.keyboard_voice_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () async {
                    Future<void> requestPermissions() async {
                      PermissionStatus status =
                          await Permission.microphone.request();
                      if (!status.isGranted) {
                        if (context.mounted) {
                          showTipMessage(context, '未授予麦克风权限');
                        }
                        throw Exception('未授予麦克风权限');
                      }
                    }

                    setState(() {
                      isAudio = !isAudio;
                    });
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.symmetric(horizontal: isAudio ? 0 : 10.0),
                    margin: const EdgeInsets.only(bottom: 4.0),
                    constraints: const BoxConstraints(
                      minHeight: 42,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(30),
                          spreadRadius: 3,
                          blurRadius: 25,
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: isAudio
                        ? GestureDetector(
                            // onLongPressDown: (_) => _handleAudio(),
                            // onTapUp: (_) => _hideBottomSheet(),
                            // onHorizontalDragEnd: (_) => _hideBottomSheet(),
                            // onLongPressUp: _hideBottomSheet,
                            // onHorizontalDragUpdate: _handleOverlap,
                            // onLongPressMoveUpdate: _handleOverlap,
                            onLongPressDown: (_) {
                              setState(() {
                                showAudioPanel = true;
                              });
                            },
                            onLongPressUp: () {
                              setState(() {
                                showAudioPanel = false;
                              });
                            },
                            onLongPressMoveUpdate: _handleOverlap,
                            child: Container(
                              height: 42,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: const Text('按住说话'),
                            ),
                          )
                        : TextField(
                            controller: _controller,
                            minLines: 1,
                            maxLines: 8,
                            decoration: null,
                            focusNode: _focusNode,
                            onChanged: (value) {
                              setState(() {
                                showSendButton = value.isNotEmpty;
                              });
                            },
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                CustomIconButton(
                  icon: Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    // 监听键盘状态
                    // print(SystemChannels.textInput.invokeMethod('TextInput.hide'));
                    SystemUtils.hideSoftKeyBoard(context);
                    Future.delayed(const Duration(milliseconds: 100), () {
                      setState(() {
                        showPanel = true;
                      });
                    });
                  },
                ),
                const SizedBox(width: 8),
                Visibility(
                  visible: showSendButton,
                  child: FilledButton(
                    onPressed: () {
                      if (widget.onSend != null) {
                        widget.onSend!({
                          'content': _controller.text,
                          'type': messageType['text']?['value'],
                        });
                        _controller.text = '';
                      }
                    },
                    style: FilledButton.styleFrom(
                      // backgroundColor: const Color(0xFF34A047),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.all(0),
                    ),
                    child: const Text(
                      '发送',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 80),
              curve: Curves.easeInOut,
              height: showPanel ? 100 : 0,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 4,
                children: [
                  CustomIconButton(
                    icon: Icons.photo,
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      print('图片');
                      _pickImage();
                    },
                  ),
                  CustomIconButton(
                    icon: Icons.camera_alt_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      print('照相');
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
          ],
        ),
      ),
    );
  }
}
