import 'package:flutter/material.dart';
import 'package:lifebeat/components/lbtextfield.dart';
import 'package:lifebeat/components/surface.dart';
import 'package:lifebeat/main.dart';
import 'package:lifebeat/utils/task_funcs.dart';

import '../utils/date_funcs.dart';

class GoalPropertiesPage extends StatefulWidget {
  const GoalPropertiesPage({
    super.key,
  });

  @override
  State<GoalPropertiesPage> createState() => _GoalPropertiesPageState();
}

class _GoalPropertiesPageState extends State<GoalPropertiesPage> {
  DateTime beginDate = DateTime.now();
  DateTime endDate = DateTime.now();
  
  final nameController = TextEditingController();
  final descController = TextEditingController();
  late final beginController = TextEditingController(text: TaskFuncs.ymdDate(beginDate));
  late final endController = TextEditingController(text: TaskFuncs.ymdDate(endDate));


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
            left: 20,
            right: 20,
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отмена'),
                )
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    objectbox.addGoal(
                      nameController.text, 
                      descController.text, 
                      beginDate, 
                      endDate,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Продолжить'),
                )
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Surface(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 16,
                    bottom: 16,
                  ),
                  child: Column(
                    children: [
                      LBTextField(
                        controller: nameController,
                        label: const Text('Название'),
                      ),
                      const SizedBox(height: 15),
                      LBTextField(
                        keyboardType: TextInputType.multiline,
                        controller: descController,
                        label: const Text('Описание'),
                      ),
                      const SizedBox(height: 15),
                      LBTextField(
                        controller: beginController,
                        label: const Text('Дата начала'),
                        readOnly: true,
                        onTap: () async {
                          beginDate = await chooseDate(beginDate, context);
                          beginController.text = TaskFuncs.ymdDate(beginDate);
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 15),
                      LBTextField(
                        controller: endController,
                        label: const Text('Дата окончания'),
                        readOnly: true,
                        onTap: () async {
                          endDate = await chooseDate(endDate, context);
                          endController.text = TaskFuncs.ymdDate(endDate);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60)
              ],
            ),
          ),
        ),
      ),
    );
  }
}