import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Helpers/util.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final double? width;
  final double? height;
  final String imageUrl;
  final BoxFit? fit;

  const CustomImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    bool isLocalImage =
        imageUrl.startsWith(r'/data/user/0/com.example.chat_app/app_flutter/');

    return isLocalImage
        ? Image.file(
            File(imageUrl),
            width: width,
            height: height,
            fit: fit,
          )
        : CachedNetworkImage(
            imageUrl: getImageUrl(imageUrl),
            width: width,
            height: height,
            fit: fit,
          );
  }
}
