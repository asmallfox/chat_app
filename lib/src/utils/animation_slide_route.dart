import 'package:flutter/cupertino.dart';

Route animationSlideRoute(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}
