import 'package:flutter/material.dart';
import 'package:lifebeat/components/lbtextfield.dart';
import 'package:lifebeat/entities/task.dart';
import 'package:lifebeat/main.dart';
import 'package:lifebeat/utils/date_funcs.dart';
import 'package:lifebeat/utils/task_funcs.dart';
import '../components/surface.dart';

class TaskPropertiesPage extends StatefulWidget {
  // Update Task if task property provided
  // Create new Task if task property not provided
  const TaskPropertiesPage({
    super.key,
    this.task,
    required this.date,
  });

  final Task? task;
  final DateTime date;

  @override
  State<TaskPropertiesPage> createState() => _TaskPropertiesPageState();
}

class _TaskPropertiesPageState extends State<TaskPropertiesPage> {
  late final task = widget.task;
  late DateTime date = widget.date;
  late final nameController = TextEditingController(text: task?.text);
  late final dateController = TextEditingController(text: task != null ?   TaskFuncs.ymdDate(task!.date) : TaskFuncs.ymdDate(date));
  late String dayTime = task != null ? task!.dayTime : DayTime.morning;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Surface(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      top: 15,
                    ),
                    child: Column(
                      children: [
                        LBTextField(
                          label: const Text('Название'),
                          controller: nameController,
                        ),
                        const SizedBox(height: 15),
                        LBTextField(
                          label: const Text('Дата'),
                          controller: dateController,
                          readOnly: true,
                          onTap: () async {
                            date = await chooseDate(date, context);
                            dateController.text = TaskFuncs.ymdDate(date);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Surface(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Время суток'),
                        DropdownButton(
                          value: dayTime,
                          items: const [
                            DropdownMenuItem<String>(value: DayTime.morning, child: Text('Утро')),
                            DropdownMenuItem<String>(value: DayTime.afternoon, child: Text('День')),
                            DropdownMenuItem<String>(value: DayTime.evening, child: Text('Вечер')),
                          ],
                          onChanged: (value) => setState(() => dayTime = value!),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Отмена')
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (task == null) {
                          objectbox.addTask(
                            nameController.text.trim(),
                            date,
                            dayTime,
                          );
                        } else {
                          Task updatedTask = task!;
                          task!.text = nameController.text;
                          task!.dayTime = dayTime;
                          task!.date = date;
                          objectbox.updateTask(updatedTask);
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text('Подтвердить')
                    )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}