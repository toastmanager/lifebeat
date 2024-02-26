import 'package:flutter/material.dart';

class ProgressCircle extends StatefulWidget {
  const ProgressCircle({
    super.key,
    required this.progress,
    this.isExpired = false,
  });

  final double progress;
  final bool isExpired;

  @override
  State<ProgressCircle> createState() => _ProgressCircleState();
}

class _ProgressCircleState extends State<ProgressCircle> {
  @override
  Widget build(BuildContext context) {
    Widget child = Text(
      '${widget.progress.toInt()}%',
      style: Theme.of(context).textTheme.headlineSmall,
    );

    double turns = 0;

    if (widget.progress == 100) {
      turns++;
      child = const Icon(Icons.check_rounded);
    }
    if (widget.progress < 100 && widget.isExpired) {
      turns++;
      child = const Icon(Icons.close_rounded);
    }

    return SizedBox(
      height: 52,
      width: 52,
      child: Stack(
        children: [
          Center(
            child: TweenAnimationBuilder<double>(
                tween: Tween(
                    begin: widget.progress / 100, end: widget.progress / 100),
                duration: const Duration(milliseconds: 200),
                builder: (context, value, _) {
                  return CircularProgressIndicator(
                    backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(170),
                    color: Theme.of(context).colorScheme.primary,
                    strokeAlign: 2.5,
                    strokeWidth: 5,
                    value: value,
                  );
                }),
          ),
          Center(
            child: AnimatedRotation(
                turns: turns,
                duration: const Duration(milliseconds: 200),
                child: child),
          ),
        ],
      ),
    );
  }
}
