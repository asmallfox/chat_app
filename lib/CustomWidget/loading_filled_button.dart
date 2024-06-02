import 'package:flutter/material.dart';

class LoadingFilledButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool enabled;
  final bool loading;
  final double height;
  final Widget child;

  const LoadingFilledButton({
    super.key,
    this.enabled = true,
    this.loading = false,
    this.height = 40,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: FilledButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          if (loading || onPressed == null) return;
          onPressed!();
        },
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
                  color: Colors.white,
                ),
              )
            : child,
      ),
    );
  }
}
