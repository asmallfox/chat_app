import 'package:flutter/material.dart';

class Mine extends StatefulWidget {
  const Mine({
    super.key,
  });

  @override
  State<Mine> createState() => _MineState();
}

class _MineState extends State<Mine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mine'),
      ),
      body: Center(
        child: Text('This is the Mine page'),
      ),
    );
  }
}
