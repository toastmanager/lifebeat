import 'package:flutter/material.dart';
import 'package:lifebeat/main.dart';
import 'package:lifebeat/utils/task_funcs.dart';
import '../entities/task.dart';

class TaskCheckCircle extends StatefulWidget {
  const TaskCheckCircle({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<TaskCheckCircle> createState() => _TaskCheckCircleState();
}

class _TaskCheckCircleState extends State<TaskCheckCircle> {
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = const BoxDecoration();
    Widget child = CircularProgressIndicator(
      value: 1,
      strokeWidth: 5,
      strokeAlign: -1,
      color: Theme.of(context).colorScheme.primary,
    );
    if (widget.task.status == false &&
      TaskFuncs.isTaskBeforeByDays(widget.task.date, DateTime.now())  ||
      (
        TaskFuncs.isTaskEqualByDays(widget.task.date, DateTime.now()) &&
        TaskFuncs.isDateAfterTaskDayTime(widget.task, DateTime.now())
      )
    ) {
        decoration = const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF3F33),
              Color(0xFF99261F),
            ]
          )
        );
        child = const Icon(Icons.close);
    }
    if (widget.task.status == true) {
      decoration = const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE5D32E),
            Color(0xFFFF431A),
          ]
        )
      );
      child = const Icon(Icons.done);
    }
    return InkWell(
      onTap: () {
        setState(() {
          widget.task.switchStatus();
          objectbox.switchTask(widget.task.id);
        });
      },
      child: SizedBox(
        child: Stack(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: decoration,
              child: child,
            )
          ],
        ),
      ),
    );
  }
}