import 'package:chat_app/CustomWidget/back_icon_button.dart';
import 'package:chat_app/CustomWidget/custom_icon_button.dart';
import 'package:chat_app/src/widgets/key_board_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return KeyboardContainer(
      child: Scaffold(
        appBar: AppBar(
          leading: BackIconButton(
            backFn: () {},
          ),
          title: const Text('谁在聊天...'),
          actions: [
            IconButton(
              onPressed: () async {
                print('语音');
              },
              icon: const Icon(Icons.phone),
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              onPressed: () {
                print('视频');
              },
              icon: const Icon(Icons.videocam_sharp),
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              onPressed: () {
                print('更多');
              },
              icon: const Icon(Icons.more_vert_rounded),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: Text('聊天区域'),
              ),
            ),
            Container(
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
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
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
            )
          ],
        ),
      ),
    );
  }
}
