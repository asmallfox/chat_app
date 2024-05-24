import 'package:flutter/material.dart';
import 'package:chat_app/Helpers/AuthenticationWrapper.dart';

class PageLayout extends StatelessWidget {
  const PageLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: AuthenticationWrapper());
  }
}
