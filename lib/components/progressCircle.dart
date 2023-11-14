import 'package:flutter/material.dart';
import 'package:lifebeat/scripts/vars.dart';

class ProgressCircle extends StatelessWidget {
  ProgressCircle({
    super.key,
    required this.progress,
  });

  double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: 52,
      child: Stack(
        children: [
          Center(
            child: CircularProgressIndicator(
              backgroundColor: AppColors.purpleDark,
              color: AppColors.purple,
              strokeAlign: 2.5,
              strokeWidth: 5,
              value: progress / 100,
            ),
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
