import 'package:flutter/material.dart';
import 'package:lifebeat/components/navbar.dart';
import 'package:lifebeat/components/task.dart';
import 'package:lifebeat/models/goal_model.dart';
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Center(
                child: Text('Расписание',
                    style: AppTexts.headingBold,
                    textAlign: TextAlign.center)
              ),
              Task(model: GoalModel(checkpoints: [], completed: false, deadline: DateTime.now(), name: 'Подготовить дизайн', id: 90, description: ''), updateGoals: () {})
            ],
          ),
        ),
      ),
    );
  }
}
