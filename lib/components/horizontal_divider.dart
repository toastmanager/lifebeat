import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 3,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
