import 'dart:io';

import 'package:chat_app/src/utils/share.dart';
import 'package:flutter/material.dart';

class ContentItemMedia extends StatefulWidget {
  final Map msgItem;
  final bool isSelf;
  const ContentItemMedia({
    super.key,
    required this.msgItem,
    this.isSelf = true,
  });

  @override
  State<ContentItemMedia> createState() => _ContentItemAudioState();
}

class _ContentItemAudioState extends State<ContentItemMedia> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: Colors.black,
                        child: isNetSource(widget.msgItem['content'])
                            ? Image.network(
                                getSourceUrl(widget.msgItem['content']),
                                fit: BoxFit.cover,
                              )
                            : Image.file(File(widget.msgItem['content'])),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                              },
                              icon: const Icon(Icons.download_rounded),
                              color: Colors.grey.shade400,
                              iconSize: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      },
      child: Container(
        child: isNetSource(widget.msgItem['content'])
            ? Image.network(
                getSourceUrl(widget.msgItem['content']),
                fit: BoxFit.cover,
              )
            : Image.file(File(widget.msgItem['content'])),
      ),
    );
  }
}
