import 'package:flutter/material.dart';
import 'package:chat_app/Helpers/auth_wrapper.dart';

class PageLayout extends StatelessWidget {
  const PageLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AuthWrapper());
  }
}
