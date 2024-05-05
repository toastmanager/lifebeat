import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:lifebeat/components/surface.dart';
import 'package:lifebeat/components/task_checkcircle.dart';
import 'package:lifebeat/entities/task.dart';
import 'package:lifebeat/main.dart';
import 'package:lifebeat/screens/task_properties_page.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                TaskCheckCircle(
                  task: task,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    task.text,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                )
              ],
            ),
          ),
          TaskPopup(
            task: task,
          )
        ],
      ),
    );
  }
}

class TaskPopup extends StatelessWidget {
  const TaskPopup({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TaskPropertiesPage(
              date: task.date,
              task: task,
            ))
          ),
          child: Text(AppLocalizations.of(context)!.edit)
        ),
        PopupMenuItem(
          onTap: () => objectbox.deleteTask(task.id),
          child: Text(AppLocalizations.of(context)!.delete)
        ),
      ],
    );
  }
}