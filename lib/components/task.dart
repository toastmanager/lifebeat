import 'package:flutter/material.dart';
import 'package:lifebeat/components/progressCircle.dart';
import 'package:lifebeat/models/goal_model.dart';
import 'package:lifebeat/scripts/vars.dart';
import 'package:lifebeat/pages/task_details.dart';

class Task extends StatefulWidget {
  Task({super.key, required this.model, required this.updateGoals});

  GoalModel model;
  Function updateGoals;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  void updateTaskComponent(GoalModel newModel) {
    setState(() {
      widget.model = newModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.model.name;
    bool completed = widget.model.completed;
    DateTime deadline = widget.model.deadline;
    double progress = widget.model.progress;
    int timeLeft = deadline.difference(DateTime.now()).inDays;


    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => TaskDetailsPage(model: widget.model, updateTaskComponent: updateTaskComponent, updateGoals: widget.updateGoals,)))
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
              ProgressCircle(progress: progress),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
