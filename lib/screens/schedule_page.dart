import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifebeat/components/task.dart';
import 'package:lifebeat/models/task_model.dart';
import 'package:lifebeat/screens/new_task_goal_page.dart';
import 'package:lifebeat/styles/text_styles.dart';
import 'package:lifebeat/utils/database/database.dart';
import 'package:lifebeat/utils/text_values.dart';
import '../components/horizontal_divider.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime currentDay = DateTime.now();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _timer = Timer.periodic(
          const Duration(minutes: 1), (timer) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget freeTimeDivider(String freeTime, Function() addTask) {
    return InkWell(
      onTap: () => addTask(),
      hoverColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
        ),
        child: Row(
          children: [
            const HorizontalDivider(),
            const SizedBox(width: 20),
            Text(
              freeTime,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20),
            const HorizontalDivider(),
          ],
        ),
      ),
    );
  }

  List<TaskModel> sortTasks(List<TaskModel> tasksList) {
    // sort tasks by end time
    tasksList.sort((a, b) => a.endTime.compareTo(b.endTime));
    return tasksList;
  }

  Widget scheduleDayPicker(Function() updateState) {
    DateTime lastDay = currentDay.subtract(const Duration(days: 1));
    DateTime nextDay = currentDay.add(const Duration(days: 1));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          color: Theme.of(context).colorScheme.onBackground,
          onPressed: () {
            currentDay = lastDay;
            updateState();
          },
        ),
        Text(
          lastDay.day.toString(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: AppTexts.bodySize - 2,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurfaceVariant
          ),
        ),
        const SizedBox(width: 5),
        Text(
          currentDay.day.toString(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: AppTexts.bodySize + 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          nextDay.day.toString(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: AppTexts.bodySize - 2,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurfaceVariant
          ),
        ),
        IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
            color: Theme.of(context).colorScheme.onBackground,
            onPressed: () {
              currentDay = nextDay;
              updateState();
            },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: NewTaskPage(
                        optionalStartTime: currentDay,
                        optionalEndTime: currentDay,
                      ),
                )),
              )
              .then((value) => setState(() {})),
          elevation: 0,
          shape: const OvalBorder(),
          child: const Icon(CupertinoIcons.plus),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Text(
                TextValue.scheduleHeading,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 20),
            scheduleDayPicker(() {
              setState(() {});
            }),
            const SizedBox(height: 20),
            FutureBuilder<List<TaskModel>>(
              future: DBHelper.certainDayTasks(currentDay),
              builder: (context, snapshot) {
                updateTasks() {
                  setState(() {});
                }
    
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Text(TextValue.scheduleDayEmpty);
                  }
                  List<TaskModel> tasksList = sortTasks(snapshot.data!);
                  return Flexible(
                      child: ListView.builder(
                    itemCount: tasksList.length,
                    itemBuilder: (context, index) {
                      final TaskModel task = tasksList[index];
                      List<Widget> widgets = [
                        Task(
                            taskId: task.id,
                            updateItems: () => updateTasks()),
                      ];
    
                      if (index > 0) {
                        Duration freeTime = task.startTime
                            .difference(tasksList[index - 1].endTime);
                        if (freeTime.inMinutes > 0) {
                          String freeTimeText =
                              "${freeTime.inMinutes - freeTime.inHours * 60} минут";
                          freeTime.inHours > 0
                              ? freeTimeText =
                                  "${freeTime.inHours} часа $freeTimeText"
                              : null;
                          widgets = <Widget>[
                                freeTimeDivider(freeTimeText, () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                        builder: (context) => Scaffold(
                                          body: NewTaskPage(
                                                optionalStartTime:
                                                    tasksList[index - 1]
                                                        .endTime,
                                                optionalEndTime: task.startTime,
                                              ),
                                        )),
                                      )
                                      .then((value) => updateTasks());
                                })
                              ] +
                              widgets;
                        } else {
                          widgets =
                              <Widget>[const SizedBox(height: 20)] + widgets;
                        }
                      }
    
                      if (index == tasksList.length - 1) {
                        widgets += <Widget>[const SizedBox(height: 80)];
                      }
    
                      return Column(
                        children: widgets,
                      );
                    },
                  ));
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
