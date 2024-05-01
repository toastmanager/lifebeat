import 'package:flutter/material.dart';
import 'package:lifebeat/entities/task.dart';
import 'package:lifebeat/main.dart';
import '../components/surface.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final nameController = TextEditingController();
  late final date = widget.date;
  String dayTime = DayTime.morning;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Surface(
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          label: Text('Задача')
                        ),
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
                      objectbox.addTask(
                        nameController.text,
                        date,
                        dayTime,
                      );
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
    );
  }
}