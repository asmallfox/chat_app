import 'dart:io';

import 'package:chat_app/src/utils/hive_util.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? url;
  final double radius;
  final double borderRadius;
  final bool isCircle;

  const Avatar({
    super.key,
    this.url,
    this.radius = 20,
    this.borderRadius = 6,
    this.isCircle = false,
  });

  Future<String?> _getAvatarUrl() async {
    if (url != null) {
      return await UserHive.getNetworkUrl(url!);
    }
    return null;
  }

  Widget _getAvatarWidget({String? avatarUrl, bool loading = false}) {
    if (isCircle) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: avatarUrl == null
            ? const AssetImage('assets/images/default_avatar.png')
            : FileImage(File(avatarUrl)),
      );
    } else {
      return SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: avatarUrl == null
              ? Image.asset('assets/images/default_avatar.png')
              : Image.file(File(avatarUrl)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final urlMap = UserHive.urlMap;

    String? avatarUrlMap = urlMap[url.toString()];

    if (url == null) {
      return _getAvatarWidget();
    } else if (avatarUrlMap == null) {
      return FutureBuilder(
          future: _getAvatarUrl(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _getAvatarWidget(loading: true);
            } else if (snapshot.hasError) {
              return _getAvatarWidget();
            } else {
              String? avatarUrl = snapshot.data;
              return _getAvatarWidget(avatarUrl: avatarUrl);
            }
          });
    } else {
      return _getAvatarWidget(avatarUrl: avatarUrlMap);
    }
  }
}
