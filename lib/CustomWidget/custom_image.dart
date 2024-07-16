import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Helpers/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomImage extends StatelessWidget {
  final double? width;
  final double? height;
  final String imageUrl;

  const CustomImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
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
            fit: BoxFit.cover,
          )
        : CachedNetworkImage(
            imageUrl: getImageUrl(imageUrl),
            width: width,
            height: height,
          );
  }
}
