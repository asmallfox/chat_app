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
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 80,
            child: ListTile(
              minTileHeight: 80,
              leading: Container(
                width: 80,
                height: 80,
                color: Colors.deepPurple[400],
              ),
              title: const Text('小狐幽'),
              subtitle: const Text('账号：smallfox@99'),
            ),
          )
        ],
      ),
    );
  }
}
