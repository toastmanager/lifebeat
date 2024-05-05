import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifebeat/components/task_tile.dart';
import 'package:lifebeat/entities/task.dart';
import 'package:lifebeat/main.dart';
import 'package:lifebeat/utils/task_funcs.dart';

import '../utils/providers.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late DateTime date = ref.watch(tasksDay);
    return StreamBuilder<List<Task>>(
      stream: objectbox.getDayTasks(date),
      builder: (context, snapshot) {
        if (snapshot.data?.isNotEmpty ?? false) {
          List<List<Task>> groupedTaskList = TaskFuncs.groupedTasks(snapshot.data ?? []);
          List<Widget> widgets = [];

          for (int i = 0; i < groupedTaskList.length; i++) {
            if (i == 0 && groupedTaskList[i].isNotEmpty) {
              widgets.add(
                Text(
                  AppLocalizations.of(context)!.morning,
                  style: Theme.of(context).textTheme.headlineSmall,
                )
              );
              widgets.add(const SizedBox(height: 20));
            }
            if (i == 1 && groupedTaskList[i].isNotEmpty) {
              widgets.add(
                Text(
                  AppLocalizations.of(context)!.afternoon,
                  style: Theme.of(context).textTheme.headlineSmall,
                )
              );
              widgets.add(const SizedBox(height: 20));
            }
            if (i == 2 && groupedTaskList[i].isNotEmpty) {
              widgets.add(
                Text(
                  AppLocalizations.of(context)!.evening,
                  style: Theme.of(context).textTheme.headlineSmall,
                )
              );
              widgets.add(const SizedBox(height: 20));
            }
            for (Task task in groupedTaskList[i]) {
              widgets.add(
                TaskTile(
                  key: Key("task-${task.id}"),
                  task: task,
                )
              );
              widgets.add(const SizedBox(height: 20));
            }
            if (i == 2) {
              widgets.add(const SizedBox(height: 40));
            }
          }

          return ListView(
            shrinkWrap: true,
            children: widgets,
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return Text(AppLocalizations.of(context)!.no_tasks_for_day);
        }
      },
    );
  }
}