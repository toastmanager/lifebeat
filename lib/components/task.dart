import 'package:flutter/material.dart';
import 'package:lifebeat/components/progressCircle.dart';
import 'package:lifebeat/models/task_model.dart';
import 'package:lifebeat/scripts/database/database.dart';
import 'package:lifebeat/scripts/vars.dart';
import 'package:lifebeat/pages/task_details.dart';

class Task extends StatefulWidget {
  const Task({super.key, required this.taskId, required this.updateItems});

  final int taskId;
  final Function() updateItems;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {

    return FutureBuilder<TaskModel>(
      future: DBHelper.getTaskById(widget.taskId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TaskModel model = snapshot.data!;
          String name = model.name;
          DateTime startTime = model.startTime;
          DateTime endTime = model.endTime;
          double progress = model.progress;
          String timeLeft = model.timeLeft;
          
          void updateTaskComponent() async {
            model = await DBHelper.getTaskById(widget.taskId);
            setState(() {});
          }
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => TaskDetailsPage(
                            taskId: widget.taskId,
                            updateItemComponent: () => updateTaskComponent(),
                            updateItems: widget.updateItems,
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
                                timeLeft,
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
                                '${startTime.hour}:${startTime.minute} - ${endTime.hour}:${endTime.minute}',
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
        } else {
          return const Text('Данные отсутствуют');
        }
      }
    );
  }
}
