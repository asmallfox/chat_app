import 'package:flutter/cupertino.dart';

class CustomModel extends StatelessWidget {
  final List<Widget> children;

  const CustomModel({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          ...children,
          // Visibility(
          //   child: Positioned.fill(
          //     child: Container(
          //       color: const Color.fromRGBO(0, 0, 0, 0.5),
          //       child: ,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
