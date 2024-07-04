import 'package:flutter/material.dart';

class BackIconButton extends StatelessWidget {
  final Function? backFn;
  const BackIconButton({
    super.key,
    this.backFn,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_rounded),
      onPressed: () {
        if (backFn != null) {
          backFn!();
        }
        Navigator.pop(context);
      },
    );
  }
}
