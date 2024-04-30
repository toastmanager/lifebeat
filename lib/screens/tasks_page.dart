import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifebeat/screens/new_task_page.dart';
import 'package:lifebeat/screens/tasks_list_screen.dart';
import 'package:lifebeat/utils/providers.dart';


class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewTaskPage(
                date: ref.watch(tasksDay),
              ),
            ),
          ),
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(CupertinoIcons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Расписание',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            const ScheduleDayPicker(),
            const SizedBox(height: 20),
            const TaskListScreen(),
          ],
        ),
      ),
    );
  }
}

class ScheduleDayPicker extends ConsumerWidget {
  const ScheduleDayPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = ref.watch(tasksDay);
    final DateTime lastDay = date.subtract(const Duration(days: 1));
    final DateTime nextDay = date.add(const Duration(days: 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            ref.read(tasksDay.notifier).state = lastDay;
          },
          icon: const Icon(Icons.arrow_left_rounded)
        ),
        Text(
          lastDay.day.toString(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: 12,
            color: const Color(0xFF667180),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          "${date.day < 10 ? 0 : ''}${date.day}.${date.month < 10 ? 0 : ''}${date.month}",
          style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16),
        ),
        const SizedBox(width: 5),
        Text(
          nextDay.day.toString(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: 12,
            color: const Color(0xFF667180),
          ),
        ),
        IconButton(
          onPressed: () {
            ref.read(tasksDay.notifier).state = nextDay;
          },
          icon: const Icon(Icons.arrow_right_rounded)
        ),
      ],
    );
  }
}