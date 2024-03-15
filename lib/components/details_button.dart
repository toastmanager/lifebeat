import 'package:flutter/material.dart';

class DetailButton extends StatefulWidget {
  const DetailButton({
    super.key,
    required this.child,
    required this.action,
    this.color,
  });

  final Widget child;
  final Function() action;
  final Color? color;

  @override
  State<DetailButton> createState() => _DetailButtonState();
}

class _DetailButtonState extends State<DetailButton> {
  final BorderRadius buttonBorderRadius = BorderRadius.circular(8);
  late final Color color = widget.color == null
    ? Theme.of(context).colorScheme.surface
    : widget.color!;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: InkWell(
        onTap: () => widget.action(),
        borderRadius: buttonBorderRadius,
        child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: buttonBorderRadius,
            ),
            height: 40,
            child: Center(child: widget.child)),
      ),
    );
  }
}