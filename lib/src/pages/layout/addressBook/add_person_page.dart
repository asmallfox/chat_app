import 'package:flutter/material.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({
    super.key,
  });

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Person'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: TextField(
              
            ),
          )
        ],
      ),
    );
  }
}
