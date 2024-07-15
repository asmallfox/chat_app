import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Helpers/util.dart';
import 'package:flutter/material.dart';

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
    return CachedNetworkImage(
      imageUrl: getImageUrl(imageUrl),
      width: width,
      height: height,
    );
  }
}
