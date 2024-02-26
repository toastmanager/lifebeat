import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifebeat/components/navbar.dart';
import 'package:lifebeat/components/task.dart';
import 'package:lifebeat/models/task_model.dart';
import 'package:lifebeat/pages/main_wrapper.dart';
import 'package:lifebeat/pages/new_task_goal_page.dart';
import 'package:lifebeat/scripts/database/database.dart';
import 'package:lifebeat/scripts/text.dart';
import 'package:lifebeat/scripts/vars.dart';
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
            Text(freeTime),
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
            onPressed: () {
              currentDay = lastDay;
              updateState();
            },
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20)),
        Text(
          lastDay.day.toString(),
        ),
        const SizedBox(width: 5),
        Text(
          currentDay.day.toString(),
        ),
        const SizedBox(width: 5),
        Text(
          nextDay.day.toString(),
        ),
        IconButton(
            onPressed: () {
              currentDay = nextDay;
              updateState();
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 20)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        bottomNavigationBar: const Navbar(
          currentPage: Routes.schedule,
        ),
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(
                  builder: (context) => MainWrapper(
                      currentPage: '/new_task',
                      child: NewTaskPage(
                        optionalStartTime: currentDay,
                        optionalEndTime: currentDay,
                      )),
                ))
                .then((value) => setState(() {})),
            backgroundColor: AppColors.purple,
            shape: const OvalBorder(),
            child: const Icon(CupertinoIcons.plus),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Center(
                  child: Text(TextValue.scheduleHeading,
                      textAlign: TextAlign.center)),
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
                                          builder: (context) => MainWrapper(
                                              currentPage: '/new_task',
                                              child: NewTaskPage(
                                                optionalStartTime:
                                                    tasksList[index - 1]
                                                        .endTime,
                                                optionalEndTime: task.startTime,
                                              )),
                                        ))
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
      ),
    );
  }
}
