import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? prefixIconPath;
  final bool isPassword;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final Color fillColor;
  final EdgeInsetsGeometry margin;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIconPath,
    this.isPassword = false,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.fillColor = Colors.white,
    this.margin = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0x001d1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          )
        ],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        onChanged: widget.onChanged,
        onSubmitted: (_) => widget.onSubmitted?.call(),
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Color(0xffDDDADA), fontSize: 14),
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: widget.prefixIconPath != null
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(widget.prefixIconPath!,
                      width: 20, height: 20),
                )
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () => setState(() {
                    _obscureText = !_obscureText;
                  }),
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
