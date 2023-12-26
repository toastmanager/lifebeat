import 'package:flutter/material.dart';
import 'package:lifebeat/models/goal_model.dart';
import 'package:lifebeat/scripts/task_funcs.dart';
import 'package:lifebeat/scripts/vars.dart';
import 'package:lifebeat/components/goal.dart';
import 'package:lifebeat/scripts/database/database.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
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
                updateGoals() {
                  setState(() {});
                }

                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Text('Цели отсутствуют');
                  }
                  List<GoalModel> goalsList = snapshot.data!.toList();
                  goalsList = sortedGoalsList(goalsList);
                  return Flexible(
                    child: ListView.separated(
                        itemCount: goalsList.length,
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 25,
                            ),
                        itemBuilder: (context, index) {
                          return Goal(
                              model: goalsList[index],
                              updateGoals: () => updateGoals());
                        }),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
