import 'package:flutter/material.dart';
import 'package:lifebeat/main.dart';

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
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    label: Text('Задача')
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
                      var id = objectbox.addTask(
                        nameController.text,
                        date,
                      );
                      print(id);
                      print(date);
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