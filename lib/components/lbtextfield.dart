import 'package:flutter/material.dart';

class LBTextField extends StatelessWidget {
  const LBTextField({
    super.key,
    this.controller,
    this.label,
    this.obscureText,
    this.readOnly,
    this.onSubmitted,
    this.onChanged,
    this.onTap,
    this.keyboardType,
  });

  final TextEditingController? controller;
  final Widget? label;
  final bool? obscureText;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            width: 2,
          ),
        ),
        label: label,
      ),
      maxLines: null,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText ?? false,
      readOnly: readOnly ?? false,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}