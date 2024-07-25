import 'dart:io';

import 'package:chat_app/CustomWidget/custom_icon_button.dart';
import 'package:chat_app/Helpers/audio_service.dart';
import 'package:chat_app/Helpers/system_utils.dart';
import 'package:chat_app/constants/status.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final GlobalKey<_ChatTabPanelState> chatTabPanelKey = GlobalKey();

class ChatTabPanel extends StatefulWidget {
  final Function(Map)? onSend;
  final Function? startAudio;
  final Function(String)? endAudio;
  final Function? closeFocus;
  final Function? closeBlur;
  final GlobalKey audioCloseKey;

  const ChatTabPanel({
    super.key,
    this.onSend,
    this.startAudio,
    this.endAudio,
    this.closeFocus,
    this.closeBlur,
    required this.audioCloseKey,
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

  bool showAudioPanel = false;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void onHiddenPanel() {
    setState(() {
      showPanel = false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      sendImage(pickedFile.path);
    }
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // File imageFile = File(pickedFile.path);
      print('相机拍照：${pickedFile.path}');
      if (widget.onSend != null) {
        // List<int> imageBytes = imageFile.readAsBytesSync();
        // String base64Image = base64Encode(imageBytes);

        sendImage(pickedFile.path);
      }
    }
  }

  void sendImage(String path) async {
    File imageFile = File(path);

    final directory = await getApplicationDocumentsDirectory();

    List<String> pList = path.split('/');

    String extension = pList.last.split('.')[1];

    File cacheFile = File('${directory.path}/${DateTime.now().millisecondsSinceEpoch}.${extension}');

    await cacheFile.writeAsBytes(imageFile.readAsBytesSync());

    // 缓存图片到本地
    print('缓存图片的路径：${cacheFile.path}');
    widget.onSend!({
      'content': cacheFile.path,
      'file': cacheFile.readAsBytesSync(),
      'type': messageType['image']?['value']
    });
  }

  void _showBottomSheet() {
    if (widget.startAudio != null) {
      widget.startAudio!();
    }
  }

  void _handleAudio() async {
    try {
      await requestPermissions();
      await RecordingManager.startRecording();
      print('开始录音');
      _showBottomSheet();
    } catch (error) {
      print('录音错误: $error');
    }
  }

  void _hideBottomSheet() async {
    String? path = await RecordingManager.stopRecording();

    if (path != null) {
      widget.endAudio?.call(path);
    }

    print('录音完成');
  }

  void _handleOverlap(detail) {
    RenderBox renderBox =
        widget.audioCloseKey.currentContext?.findRenderObject() as RenderBox;
    Offset acOffset = renderBox.localToGlobal(Offset.zero);
    double acX = acOffset.dx;
    // double acY = acOffset.dy;
    double acW = renderBox.size.width;
    // double acH = renderBox.size.height;

    double mouseX = detail.globalPosition.dx;
    // double mouseY = detail.globalPosition.dy;

    bool isOverlap = mouseX >= acX && mouseX <= acX + acW;

    if (isOverlap) {
      widget.closeFocus?.call();
    } else {
      widget.closeBlur?.call();
    }
  }

  Future<void> requestPermissions() async {
    PermissionStatus status = await Permission.microphone.status;
    if (status.isGranted) {
      print('已经授权录音权限');
    } else {
      // 如果未授权，请求录音权限
      if (await Permission.microphone.request().isGranted) {
        print('已经授权录音权限');
      } else {
        print('授权失败');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
                            onLongPressDown: (_) => _handleAudio(),
                            onTapUp: (_) => _hideBottomSheet(),
                            onHorizontalDragEnd: (_) => _hideBottomSheet(),
                            onLongPressUp: _hideBottomSheet,
                            onHorizontalDragUpdate: _handleOverlap,
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
