import 'package:chat_app/src/utils/share.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? url;
  const Avatar({
    super.key,
    this.url,
  });
  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return Container(
        color: Colors.pink,
        child: Text('A'),
      );
    }

    return CircleAvatar(
      child: Image.network(
        getSourceUrl(url!),
      ),
    );
  }
}
