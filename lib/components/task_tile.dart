import 'package:flutter/material.dart';
import 'package:lifebeat/components/task_checkcircle.dart';
import 'package:lifebeat/entities/task.dart';

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
  late Task task;

  @override
  void initState() {
    super.initState();
    task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.outline,
        ),
        color: const Color(0xFF161E29)
      ),
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
          const TaskPopup()
        ],
      ),
    );
  }
}

class TaskPopup extends StatelessWidget {
  const TaskPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => const [
        PopupMenuItem(child: Text('Изменить')),
        PopupMenuItem(child: Text('Удалить')),
      ],
    );
  }
}