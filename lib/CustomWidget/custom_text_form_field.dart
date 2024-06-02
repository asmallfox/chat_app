import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? hintText;
  final FormFieldValidator? validator;
  final bool obscureText;
  final String? errorText;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText,
    this.validator,
    this.errorText,
    this.obscureText = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText =
        widget.obscureText; // 使用 widget.obscureText 的值初始化 _obscureText
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        errorStyle: const TextStyle(fontSize: 18),
        border: const OutlineInputBorder(),
        errorText: widget.errorText,
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey[500],
                ),
              )
            : null,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}
