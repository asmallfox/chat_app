import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? hintText;
  final String? labelText;
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
    this.labelText,
    this.obscureText = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;
  FocusNode _focusNode = FocusNode();

  final _animation = Tween(begin: 0,end: 1).animate(controller);
  late Animation<double> _opacityAnimation;

  List<Color> _bgColors = const [Color(0xFFF5F6FA), Color(0xFFF5F6FA)];

  @override
  void initState() {
    super.initState();
    _obscureText =
        widget.obscureText; // 使用 widget.obscureText 的值初始化 _obscureText
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    // 记得在销毁时移除监听器
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _bgColors = _focusNode.hasFocus
          ? const [
              Color(0xFF6562e3),
              Color(0xff46a2f5),
            ]
          : const [Color(0xFFF5F6FA), Color(0xFFF5F6FA)];
    });
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
              colors: _bgColors,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          child: TextFormField(
            focusNode: _focusNode,
            controller: widget.controller,
            obscureText: _obscureText,
            decoration: InputDecoration(
              fillColor: const Color(0xFFF5F6FA),
              filled: true,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey[400]),
              errorStyle: const TextStyle(fontSize: 18),
              // border: InputBorder.none,
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: widget.onChanged,
            validator: widget.validator,
          ),
        );
      },
    );
  }
}
