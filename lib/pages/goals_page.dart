import 'package:flutter/material.dart';
import 'package:lifebeat/models/goal_model.dart';
import 'package:lifebeat/scripts/vars.dart';
import 'package:lifebeat/components/task.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<GoalModel> goalsList = [
      GoalModel(id: 1, completed: false, name: 'Исправить режим сна', description: '', deadline: DateTime(2023, 12, 1), checkpoints: []),
      GoalModel(id: 2, completed: false, name: 'Разработать приложение', description: 'Короче проект называется Taskudy, очень клёвое приложение для учёбы, достижения целей и концентрации... да', deadline: DateTime(2023, 11, 20), checkpoints: [
        CheckpointModel(id: 1, value: false, text: 'Настроить базу данных'),
        CheckpointModel(id: 2, value: false, text: 'Сделать страницу добавления цели'),
        CheckpointModel(id: 3, value: true, text: 'Подготовить тезисы'),
        CheckpointModel(id: 4, value: true, text: 'Подготовить презентацию'),
        CheckpointModel(id: 5, value: true, text: 'Подготовить дизайн'),
      ]),
      GoalModel(id: 3, completed: false, name: 'Пройти Alan Wake 2', description: '', deadline: DateTime(2024, 1, 1), checkpoints: []),
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppColors.purple,
          shape: const OvalBorder(),
          child: Text(
            '+',
            style: AppTexts.headingBold,
          )
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Цели',
                style: AppTexts.headingBold,
              ),
              const SizedBox(height: 25),
              Flexible(
                child: ListView.separated(
                  itemCount: goalsList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 25,),
                  itemBuilder: (context, index) {
                    return Task(
                      model: goalsList[index]
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}