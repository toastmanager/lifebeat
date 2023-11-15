import 'package:flutter/material.dart';
import 'package:lifebeat/components/progressCircle.dart';
import 'package:lifebeat/models/goal_model.dart';
import 'package:lifebeat/scripts/vars.dart';
import 'package:lifebeat/pages/task_details.dart';

class Task extends StatelessWidget {
  Task({
    super.key,
    // required this.heading,
    // required this.completed,
    // required this.deadline,
    // required this.progress,
    required this.model,
  });

  GoalModel model;

  @override
  Widget build(BuildContext context) {
    String name = model.name;
    bool completed = model.completed;
    DateTime deadline = model.deadline;
    double progress = model.progress;
    int timeLeft = deadline.difference(DateTime.now()).inDays;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => TaskDetailsPage(model: model))
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.grayBlueLight,
        ),
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Row(
            children: [
              ProgressCircle(progress: progress),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: AppTexts.bodyBold,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.timer_rounded,
                        color: AppColors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '$timeLeft дней',
                        style: AppTexts.body,
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.calendar_month_rounded,
                        size: 16,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${deadline.day}.${deadline.month}.${deadline.year}',
                        style: AppTexts.body,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
