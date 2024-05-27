import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String? labelText;
  final TextEditingController? controller;

  const CustomTextInput({
    super.key,
    this.labelText,
    this.controller,
    this.onChanged,
  });

  @override
  State<CustomTextInput> createState() => _CustomTextInput();
}

class _CustomTextInput extends State<CustomTextInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          letterSpacing: 2,
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}
