import 'dart:io';

import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/helpers/recording_helper.dart';
import 'package:chat_app/src/pages/layout/message/widgets/audio_play_icon.dart';
import 'package:chat_app/src/pages/layout/message/widgets/bubble__benu_item.dart';
import 'package:chat_app/src/pages/layout/message/widgets/content_item.audio.dart';
import 'package:chat_app/src/theme/colors.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:chat_app/src/utils/message_util.dart';
import 'package:chat_app/src/utils/share.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';

class ContentItem extends StatefulWidget {
  final bool isSelf;
  final Map msgItem;
  final Map friend;
  const ContentItem({
    super.key,
    required this.isSelf,
    required this.msgItem,
    required this.friend,
  });

  @override
  State<ContentItem> createState() => _ContentItemState();
}

class _ContentItemState extends State<ContentItem> {
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        RenderObject renderObject = context.findRenderObject() as RenderObject;
        Rect paintBounds = renderObject.paintBounds;
        final translation = renderObject.getTransformTo(null).getTranslation();
        Size size = paintBounds.size;
        double menuItemWidth = 40;
        double menuItemHeight = 40;

        double right = translation.x +
            size.width -
            size.width / 2 -
            8 -
            (menuItemWidth * 2 / 2) /* 图标大小 */;
        double bottom = translation.y + size.height + 10;
        double boxCenterX = right + (menuItemWidth * 2 / 2) - 2;

        showGeneralDialog(
          context: context,
          barrierLabel: '',
          barrierColor: Colors.black.withOpacity(0.0),
          pageBuilder: (context, _, __) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                  Positioned(
                    left: right,
                    top: bottom,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: IconTheme(
                        data: const IconThemeData(
                          color: Colors.white,
                          size: 36.0,
                          weight: 0.5,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ChatBubbleMenuItem(
                              width: 40,
                              height: 40,
                              onPressed: () => _deleteMessage(context),
                              icon: const Icon(Icons.delete_outline),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            ChatBubbleMenuItem(
                              width: 40,
                              height: 40,
                              onPressed: () {
                                print('复制');
                              },
                              icon: const Icon(Icons.copy_rounded),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: boxCenterX,
                    top: bottom - 18,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: Transform.scale(
                        scaleX: -1,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            border: BorderDirectional(
                              top: BorderSide(
                                color: Colors.transparent,
                                width: 8,
                              ),
                              bottom: BorderSide(
                                color: Color(0xFF1E1E1E),
                                width: 8,
                              ),
                              start: BorderSide(
                                color: Colors.transparent,
                                width: 8,
                              ),
                              end: BorderSide(
                                color: Colors.transparent,
                                width: 8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Row(
        key: UniqueKey(),
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: widget.isSelf ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Avatar(
            url: widget.isSelf
                ? UserHive.userInfo['avatar']
                : widget.friend['avatar'],
            radius: 30,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Align(
              alignment:
                  widget.isSelf ? Alignment.centerRight : Alignment.centerLeft,
              child: _getContentItemWidget(context),
            ),
          ),
          const SizedBox(
            width: 40,
          )
        ],
      ),
    );
  }

  Widget _getContentItemWidget(BuildContext context) {
    switch (widget.msgItem['type']) {
      case 2:
        return getContentItemImage();
      case 3:
        return ContentItemAudio(
          msgItem: widget.msgItem,
          isSelf: widget.isSelf,
        );
      case 4:
        return Text('视频占位');
      case 5:
        return Text('文件占位');
      default:
        return getContentItemText();
    }
  }

  Widget getContentItemText() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      constraints: const BoxConstraints(
        minHeight: 60,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        color: widget.isSelf ? AppColors.primary : Colors.white,
      ),
      child: Text(
        widget.msgItem['content'],
        style: TextStyle(
          fontSize: 20,
          color: widget.isSelf ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget getContentItemImage() {
    return Container(
      child: isNetSource(widget.msgItem['content'])
          ? Image.network(
              getSourceUrl(widget.msgItem['content']),
              fit: BoxFit.cover,
            )
          : Image.file(File(widget.msgItem['content'])),
    );
  }

  void _deleteMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('确定删除？'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('删除'),
              onPressed: () {
                setState(() {
                  MessageUtil.delete(
                    account: widget.friend['account'],
                    sendTime: widget.msgItem['sendTime'],
                  );
                });
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
