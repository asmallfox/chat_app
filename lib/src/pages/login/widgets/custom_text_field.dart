import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? hintText;
  final String? labelText;
  final FormFieldValidator? validator;
  final bool obscureText;
  final String? errorText;

  const CustomTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText,
    this.validator,
    this.errorText,
    this.labelText,
    this.obscureText = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late bool _obscureText;
  final FocusNode _focusNode = FocusNode();

  late AnimationController _controller;

  Color colorBegin = const Color(0xFFF5F6FA); // Initial color
  Color colorEnd = const Color(0xFFF5F6FA); // Ending color

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;

    _controller = AnimationController(
      duration: const Duration(microseconds: 300),
      vsync: this,
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
        colorBegin = const Color(0xFF6562e3);
        colorEnd = const Color(0xff46a2f5);
      } else {
        _controller.reverse();
        colorBegin = const Color(0xFFF5F6FA);
        colorEnd = const Color(0xFFF5F6FA);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorBegin, colorEnd],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          child: TextFormField(
            focusNode: _focusNode,
            controller: widget.controller,
            obscureText: _obscureText,
            decoration: InputDecoration(
              fillColor: const Color.fromARGB(255, 240, 241, 248),
              filled: true,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey[400]),
              errorStyle: const TextStyle(fontSize: 18),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(6.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(6.0),
              ),
              contentPadding: const EdgeInsets.all(15.0),
              errorText: widget.errorText,
              labelText: widget.labelText,
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
            autovalidateMode: AutovalidateMode.onUserInteraction, // 自动验证
            onChanged: widget.onChanged,
            validator: widget.validator,
          ),
        );
      },
    );
  }
}
