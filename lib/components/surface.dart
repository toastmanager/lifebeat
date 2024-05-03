import 'package:flutter/material.dart';

class Surface extends StatelessWidget {
  const Surface({
    super.key,
    this.height,
    this.width,
    this.color,
    this.padding,
    required this.child,
  });

  final double? width;
  final double? height;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.outline,
        ),
        color: color ?? Theme.of(context).colorScheme.surface
      ),
      width: width,
      height: height,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(12),
        child: child,
      ),
    );
  }
}