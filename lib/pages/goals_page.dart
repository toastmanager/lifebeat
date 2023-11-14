import 'package:flutter/material.dart';
import 'package:lifebeat/models/goal_model.dart';
import 'package:lifebeat/scripts/vars.dart';
import 'package:lifebeat/components/task.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var goalsList = [
      Task(
        model: GoalModel(id: 1, completed: false, name: 'Исправить режим сна', description: '', deadline: DateTime(2023, 12, 1)),
      ),
      Task(
        model: GoalModel(id: 2, completed: false, name: 'Разработать приложение', description: '', deadline: DateTime(2023, 12, 15)),
      ),
      Task(
        model: GoalModel(id: 3, completed: false, name: 'Пройти Alan Wake 2', description: '', deadline: DateTime(2024, 1, 1)),
      ),
    ];

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -9.00),
            end: Alignment.bottomCenter,
            colors: <Color>[
              AppColors.purple,
              AppColors.grayBlueDark,
            ]
          ),
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
                      return goalsList[index];
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}