import 'package:flutter/material.dart';

class LBTextField extends StatelessWidget {
  const LBTextField({
    super.key,
    this.controller,
    this.label,
    this.obscureText,
    this.readOnly,
    this.onChanged,
    this.onTap,
  });

  final TextEditingController? controller;
  final Widget? label;
  final bool? obscureText;
  final bool? readOnly;
  final void Function(String value)? onChanged;
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
      controller: controller,
      obscureText: obscureText ?? false,
      readOnly: readOnly ?? false,
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}