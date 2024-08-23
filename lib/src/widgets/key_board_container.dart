import 'package:flutter/material.dart';

class KeyboardContainer extends StatelessWidget {
  final Widget child;

  const KeyboardContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: child,
    );
  }
}
