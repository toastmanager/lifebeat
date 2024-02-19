import 'package:flutter/material.dart';

InputDecoration textFieldDecoration(String labelText, {String? helperText, String? hintText}) {
  return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      labelText: labelText,
      helperText: helperText,
      hintText: hintText,
  );
}