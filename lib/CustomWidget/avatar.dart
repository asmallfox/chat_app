import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double size;
  final String? imageUrl;
  final bool circular;
  final bool rounded;

  const Avatar({
    super.key,
    this.size = 40,
    this.imageUrl,
    this.circular = true,
    this.rounded = false,
  });

  String getLocalUrl(String url) {
    if (url.startsWith(RegExp(r'https'))) {
      return url;
    }

    if (url.startsWith(RegExp(r'http://localhost'))) {
      return url.replaceAll(RegExp(r'http://localhost'), 'http://10.0.2.2');
    } else {
      return 'http://10.0.2.2:3000/$url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          rounded
              ? 50
              : circular
                  ? 6.0
                  : 0.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 0), // changes the position of the shadow
          ),
        ],
      ),
      child: Image(
        image: _getImageProvider(),
        fit: BoxFit.cover,
      ),
    );
  }

  ImageProvider _getImageProvider() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const AssetImage('assets/images/default_avatar.png');
    } else {
      return NetworkImage(getLocalUrl(imageUrl as String));
    }
  }
}
