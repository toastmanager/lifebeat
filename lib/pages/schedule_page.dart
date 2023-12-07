import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:lifebeat/components/navbar.dart';
import 'package:lifebeat/components/task.dart';
import 'package:lifebeat/models/task_model.dart';
import 'package:lifebeat/scripts/database/database.dart';
import 'package:lifebeat/scripts/vars.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        bottomNavigationBar: const Navbar(),
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
            onPressed: () => _newTaskMenu(context),
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
              FutureBuilder<List<TaskModel>>(
                future: DBHelper.tasks(),
                builder: (context, snapshot) {
                  updateTasks() {
                    setState(() {});
                  }

                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Text('Задачи отсутствуют');
                    }
                    List<TaskModel> tasksList = snapshot.data!;
                    return Flexible(
                        child: ListView.builder(
                      itemCount: tasksList.length,
                      itemBuilder: (context, index) {
                        final TaskModel task = tasksList[index];
                        return Task(
                            taskId: task.id, updateItems: () => updateTasks());
                        // return Text(
                        //     '${task.name} ${task.description} ${task.startTime.toIso8601String()} ${task.endTime.toIso8601String()}');
                      },
                    ));
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _newTaskMenu(BuildContext context) {
    DateTime startTime = DateTime.now();
    DateTime endTime = DateTime.now();
    String startTimeText =
        '${startTime.year}-${startTime.month}-${startTime.day} ${startTime.hour}:${startTime.minute}';
    String endTimeText =
        '${endTime.year}-${endTime.month}-${endTime.day} ${endTime.hour}:${endTime.minute}';
    TextEditingController name = TextEditingController();
    TextEditingController description = TextEditingController();

    Future<DateTime?> taskDatePicker(Function(DateTime) action) =>
        DatePicker.showDateTimePicker(context,
            minTime: DateTime(2015, 8),
            maxTime: DateTime(2101),
            currentTime: DateTime.now(),
            locale: LocaleType.ru,
            onConfirm: (date) => action(date));

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: AppColors.grayBlueDark,
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setLocalState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Новая задача',
                    style: AppTexts.bodyBold,
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                      child: TextField(
                    controller: name,
                    decoration: const InputDecoration(
                        hintText: 'Название', border: OutlineInputBorder()),
                  )),
                  const SizedBox(height: 20),
                  TextField(
                    controller: description,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Описание', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    child: InkWell(
                      onTap: () async {
                        await taskDatePicker((date) => setLocalState(() {
                              startTime = date;
                              startTimeText =
                                  '${startTime.year}-${startTime.month}-${startTime.day} ${startTime.hour}:${startTime.minute}';
                            }));
                      },
                      child: Text(startTimeText),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    child: InkWell(
                      onTap: () async {
                        await taskDatePicker((date) => setLocalState(() {
                              endTime = date;
                              endTimeText =
                                  '${endTime.year}-${endTime.month}-${endTime.day} ${endTime.hour}:${endTime.minute}';
                            }));
                      },
                      child: Text(endTimeText),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Назад')),
                      ElevatedButton(
                          onPressed: () async {
                            await DBHelper.addTask(
                              name.text,
                              description.text,
                              startTime,
                              endTime,
                            );
                            setState(() {});
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Продолжить')),
                    ],
                  ),
                ],
              );
            }));
      },
    );
  }
}
