import 'package:flutter/material.dart';

InputDecoration textFieldDecoration(String labelText) {
  return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      labelText: labelText);
}