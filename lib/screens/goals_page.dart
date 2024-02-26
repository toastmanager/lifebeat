import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifebeat/models/goal_model.dart';
import 'package:lifebeat/screens/new_task_goal_page.dart';
import 'package:lifebeat/utils/task_funcs.dart';
import 'package:lifebeat/utils/text_values.dart';
import 'package:lifebeat/components/goal.dart';
import 'package:lifebeat/utils/database/database.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                  builder: (context) => const Scaffold(body: NewGoalPage())),
                )
                .then((value) => setState(() {}));
          },
          elevation: 0,
          shape: const OvalBorder(),
          child: const Icon(CupertinoIcons.plus)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Text(
                TextValue.goalsHeading,
                style: Theme.of(context).textTheme.headlineMedium,
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
                      return const Text(TextValue.goalsEmpty);
                    }
                    List<GoalModel> goalsList = snapshot.data!.toList();
                    goalsList = sortedGoalsList(goalsList);
                    return Flexible(
                      child: ListView.separated(
                          itemCount: goalsList.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(
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
      ),
    );
  }
}
