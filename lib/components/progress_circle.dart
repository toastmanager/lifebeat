import 'package:flutter/material.dart';
import 'package:lifebeat/scripts/vars.dart';

class ProgressCircle extends StatelessWidget {
  const ProgressCircle({
    super.key,
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: 52,
      child: Stack(
        children: [
          Center(
            child: TweenAnimationBuilder<double>(
                tween: Tween(begin: progress / 100, end: progress / 100),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, _) {
                  return CircularProgressIndicator(
                    backgroundColor: AppColors.purpleDark,
                    color: AppColors.purple,
                    strokeAlign: 2.5,
                    strokeWidth: 5,
                    value: value,
                  );
                }),
          ),
          Center(
            child: Text(
              '${progress.toInt()}%',
              style: AppTexts.bodyBold,
            ),
          )
        ],
      ),
    );
  }
}
