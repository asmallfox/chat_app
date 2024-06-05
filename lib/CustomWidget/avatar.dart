import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Avatar extends StatelessWidget {
  final double size;
  final ImageProvider<Object>? image;
  final String? url;
  final bool circular;
  final bool rounded;

  const Avatar(
      {super.key,
      this.size = 40,
      this.image,
      this.url,
      this.circular = true,
      this.rounded = false});

  String getLocalUrl(String url) {
    return url.replaceAll(RegExp(r'http://localhost'), 'http://10.0.2.2');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: image ??
              NetworkImage(
                getLocalUrl(url as String),
              ),
        ),
        color: Colors.white,
        // border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(
          rounded
              ? 50
              : circular
                  ? 6.0
                  : 0.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 0), // changes the position of the shadow
          ),
        ],
      ),
    );
  }
}
