import 'package:flutter/material.dart';

class LoadingFilledButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool enabled;
  final bool loading;
  final Widget? child;

  const LoadingFilledButton({
    super.key,
    this.enabled = true,
    this.loading = false,
    this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: loading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : child,
    );
  }
}
