import 'package:flutter/material.dart';
import 'package:lifebeat/components/navbar.dart';
import 'package:lifebeat/models/goal_model.dart';
import 'package:lifebeat/pages/main_wrapper.dart';
import 'package:lifebeat/pages/new_task_goal_page.dart';
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
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        bottomNavigationBar: const Navbar(currentPage: Routes.goals),
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) => MainWrapper(
                        currentPage: Routes.goals, child: NewGoalPage()),
                  ))
                  .then((value) => setState(() {}));
            },
            backgroundColor: AppColors.purple,
            shape: const OvalBorder(),
            child: Text(
              '+',
              style: AppTexts.headingBold,
            )),
        body: Padding(
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
      ),
    );
  }
}
