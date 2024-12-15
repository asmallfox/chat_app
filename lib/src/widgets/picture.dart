import 'package:chat_app/src/utils/share.dart';
import 'package:flutter/material.dart';

class Picture extends StatelessWidget {
  final String url;
  final BoxFit? fit;

  const Picture({super.key, required this.url, this.fit});

  @override
  Widget build(context) {
    final pictureUrl = getSourceUrl(url);
    return Container(
      child: isNetSource(pictureUrl)
          ? Image.network(
              pictureUrl,
              fit: fit,
            )
          : Image.asset(
              pictureUrl,
              fit: fit,
            ),
    );
  }
}
