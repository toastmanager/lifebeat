import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifebeat/models/goal_model.dart';
import 'package:lifebeat/scripts/vars.dart';
import 'package:lifebeat/components/task.dart';
import 'package:lifebeat/scripts/database/database.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              // DBHelper.insertGoal(
              //   GoalModel(id: 2, completed: false, name: 'Разработать приложение', description: 'Короче проект называется Taskudy, очень клёвое приложение для учёбы, достижения целей и концентрации... да', deadline: DateTime(2023, 11, 20), checkpoints: [
              //     // CheckpointModel(id: 1, value: false, text: 'Настроить базу данных'),
              //     // CheckpointModel(id: 2, value: false, text: 'Сделать страницу добавления цели'),
              //     // CheckpointModel(id: 3, value: true, text: 'Подготовить тезисы'),
              //     // CheckpointModel(id: 4, value: true, text: 'Подготовить презентацию'),
              //     // CheckpointModel(id: 5, value: true, text: 'Подготовить дизайн'),
              //   ]),
              // );
              _newGoalMenu(context);
            },
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
              Text(
                'Цели',
                style: AppTexts.headingBold,
              ),
              const SizedBox(height: 25),
              FutureBuilder<List<GoalModel>>(
                future: DBHelper.goals(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<GoalModel> goalsList = snapshot.data!;
                    return Flexible(
                      child: ListView.separated(
                          itemCount: goalsList.length,
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 25,
                              ),
                          itemBuilder: (context, index) {
                            return Task(model: goalsList[index]);
                          }),
                    );
                  } else {
                    return Placeholder();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime> _selectDate(
      BuildContext context, DateTime selectedDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      selectedDate = picked;
    }
    return selectedDate;
  }

  Future<void> _newGoalMenu(BuildContext context) {
    DateTime deadline = DateTime.now();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: AppColors.grayBlueDark,
            content: Container(
              height: 300,
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Новая цель',
                    style: AppTexts.bodyBold,
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                      child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Название', border: OutlineInputBorder()),
                  )),
                  const SizedBox(height: 20),
                  Flexible(
                      child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Описание', border: OutlineInputBorder()),
                  )),
                  const SizedBox(height: 20),
                  Flexible(
                    child: InkWell(
                      onTap: () => _selectDate(context, deadline)
                          .then((value) => deadline = value),
                      child: Container(
                        child: Text(
                            '${deadline.year}-${deadline.month}-${deadline.day}'),
                      ),
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
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Продолжить')),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }
}
