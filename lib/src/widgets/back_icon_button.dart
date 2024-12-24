import 'package:flutter/material.dart';

class BackIconButton extends StatelessWidget {
  final Function? backFn;
  final Color color;
  const BackIconButton({
    super.key,
    this.backFn,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_rounded,
        color: color,
      ),
      onPressed: () {
        if (backFn != null) {
          backFn!();
        }
        Navigator.pop(context);
      },
    );
  }
}
