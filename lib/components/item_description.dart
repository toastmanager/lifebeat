import 'package:flutter/material.dart';
import 'package:lifebeat/scripts/vars.dart';

class ItemDescription extends StatelessWidget {
  const ItemDescription({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (description.isNotEmpty) const SizedBox(height: 20),
        if (description.isNotEmpty)
          SelectableText(
            description,
            style: AppTexts.body,
          ),
      ],
    );
  }
}
