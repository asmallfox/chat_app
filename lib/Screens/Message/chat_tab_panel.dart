import 'dart:convert';
import 'dart:io';

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

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

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
          'type':  messageType['image']?['value']
        });
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
                  icon: Icons.keyboard_voice_rounded,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  onPressed: () async {
                    Future<void> requestPermissions() async {
                      PermissionStatus status = await Permission.microphone.request();
                      if (!status.isGranted) {
                        throw Exception('未授予麦克风权限');
                      }
                    }
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    margin: const EdgeInsets.only(bottom: 4.0),
                    constraints: const BoxConstraints(
                      minHeight: 42,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: [
                        BoxShadow(
                          color: Theme
                              .of(context)
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
                    child: TextField(
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
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
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
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    onPressed: () {
                      print('图片');
                      _pickImage();
                    },
                  ),
                  CustomIconButton(
                    icon: Icons.camera_alt_outlined,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    onPressed: () {
                      print('照相');
                      _takePicture();
                    },
                  ),
                  CustomIconButton(
                    icon: Icons.phone,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    onPressed: () {
                      print('语音');
                    },
                  ),
                  CustomIconButton(
                    icon: Icons.videocam_sharp,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
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

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final Function()? onPressed;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.size = 24.0,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme
                .of(context)
                .colorScheme
                .primary
                .withAlpha(30),
            spreadRadius: 3,
            blurRadius: 25,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: color,
          size: size,
        ),
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        style: ButtonStyle(
          backgroundColor:
          WidgetStateProperty.all(backgroundColor ?? Colors.white),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        ),
      ),
    );
  }
}
