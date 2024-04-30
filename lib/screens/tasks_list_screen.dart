import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifebeat/components/task_tile.dart';
import 'package:lifebeat/entities/task.dart';
import 'package:lifebeat/main.dart';

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
          List<Task> taskList = snapshot.data ?? [];
          return ListView.separated(
            shrinkWrap: true,
            itemCount: snapshot.hasData ? snapshot.data!.length : 0,
            itemBuilder: (context, index) => TaskTile(
              key: Key("task-${taskList[index].id}"),
              task: taskList[index]
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 20),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return const Text('Задачи на этот день отсутствуют');
        }
      },
    );
  }
}