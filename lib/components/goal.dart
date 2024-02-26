import 'package:flutter/material.dart';
import 'package:lifebeat/components/progress_circle.dart';
import 'package:lifebeat/models/goal_model.dart';
import 'package:lifebeat/scripts/vars.dart';
import 'package:lifebeat/pages/goal_details.dart';

class Goal extends StatefulWidget {
  Goal({super.key, required this.model, required this.updateGoals});

  GoalModel model;
  final Function updateGoals;

  @override
  State<Goal> createState() => _GoalState();
}

class _GoalState extends State<Goal> {
  void updateGoalComponent(GoalModel newModel) {
    setState(() {
      widget.model = newModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.model.name;
    DateTime deadline = widget.model.deadline;
    double progress = widget.model.progress;
    int timeLeft = widget.model.daysLeft;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => GoalDetailsPage(
                      model: widget.model,
                      updateGoalComponent: updateGoalComponent,
                      updateGoals: widget.updateGoals,
                    )))
            .then((value) => setState(() {}));
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
              ProgressCircle(
                  progress: progress,
                  isExpired: widget.model.deadline.isBefore(DateTime.now())),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
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
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
