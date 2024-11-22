import 'package:chat_app/src/utils/share.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? url;
  final double? radius;

  const Avatar({
    super.key,
    this.url,
    this.radius = 20,
  });
  @override
  Widget build(BuildContext context) {
    // String avatarUrl = getSourceUrl(url!);

    return CircleAvatar(
      radius: radius,
      child: url == null
          ? Image.asset('assets/images/default_avatar.png')
          : Image.network(getSourceUrl(url!)),
    );
  }
}
