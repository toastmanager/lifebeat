import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:lifebeat/components/navbar.dart';
import 'package:lifebeat/components/task.dart';
import 'package:lifebeat/models/task_model.dart';
import 'package:lifebeat/pages/main_wrapper.dart';
import 'package:lifebeat/pages/new_task_goal_page.dart';
import 'package:lifebeat/scripts/database/database.dart';
import 'package:lifebeat/scripts/vars.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime currentDay = DateTime.now();

  Widget horizontalDivider() {
    return Expanded(
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(9),
        ),
      ),
    );
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
            horizontalDivider(),
            const SizedBox(width: 20),
            Text(freeTime,
                style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                        fontSize: AppTexts.bodyFontSize,
                        color: AppColors.lightBlue,
                        fontWeight: FontWeight.w500))),
            const SizedBox(width: 20),
            horizontalDivider(),
          ],
        ),
      ),
    );
  }

  List<TaskModel> sortTasks(List<TaskModel> tasksList) {
    // sort tasks by start time
    tasksList.sort((a, b) => a.startTime.compareTo(b.startTime));
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
          style: AppTexts.scheduleSecondary,
        ),
        const SizedBox(width: 5),
        Text(
          currentDay.day.toString(),
          style: AppTexts.scheduleMain,
        ),
        const SizedBox(width: 5),
        Text(
          nextDay.day.toString(),
          style: AppTexts.scheduleSecondary,
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
            child: Text(
              '+',
              style: AppTexts.headingBold,
            )),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Center(
                  child: Text('Расписание',
                      style: AppTexts.headingBold,
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
                      return const Text('Задачи отсутствуют');
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
                                                optionalStartTime: tasksList[index - 1]
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
