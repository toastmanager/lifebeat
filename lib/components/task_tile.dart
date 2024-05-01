import 'package:flutter/material.dart';
import 'package:lifebeat/components/surface.dart';
import 'package:lifebeat/components/task_checkcircle.dart';
import 'package:lifebeat/entities/task.dart';
import 'package:lifebeat/main.dart';

class TaskTile extends StatefulWidget {
  const TaskTile({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  late Task task = widget.task;

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              TaskCheckCircle(
                task: task,
              ),
              const SizedBox(width: 12),
              Text(
                task.text,
                style: Theme.of(context).textTheme.labelLarge,
              )
            ],
          ),
          TaskPopup(
            taskId: task.id,
          )
        ],
      ),
    );
  }
}

class TaskPopup extends StatelessWidget {
  const TaskPopup({
    super.key,
    required this.taskId,
  });

  final int taskId;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {},
          child: const Text('Изменить')
        ),
        PopupMenuItem(
          onTap: () => objectbox.deleteTask(taskId),
          child: const Text('Удалить')
        ),
      ],
    );
  }
}