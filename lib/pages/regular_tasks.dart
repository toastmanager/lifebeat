import 'package:flutter/material.dart';
import 'package:lifebeat/components/navbar.dart';
import 'package:lifebeat/components/regular_task.dart';
import 'package:lifebeat/models/regular_task_model.dart';
import 'package:lifebeat/pages/main_wrapper.dart';
import 'package:lifebeat/pages/new_task_goal_page.dart';
import 'package:lifebeat/scripts/vars.dart';
import 'package:lifebeat/scripts/database/database.dart';

class RegularTasksPage extends StatefulWidget {
  const RegularTasksPage({super.key});

  @override
  State<RegularTasksPage> createState() => _RegularTasksPageState();
}

class _RegularTasksPageState extends State<RegularTasksPage> {
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
                        currentPage: '/new_regular_task', child: NewRegularTaskPage()),
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
                  'Регулярные задачи',
                  style: AppTexts.headingBold,
                ),
                const SizedBox(height: 25),
                FutureBuilder<List<RegularTaskModel>>(
                  future: DBHelper.regularTasks(),
                  builder: (context, snapshot) {
                    updateGoals() {
                      setState(() {});
                    }

                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Text('Регулярные задачи отсутствуют');
                      }
                      List<RegularTaskModel> regularTasksList = snapshot.data!.toList();
                      return Flexible(
                        child: ListView.separated(
                            itemCount: regularTasksList.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 25,
                                ),
                            itemBuilder: (context, index) {
                              return RegularTask(
                                  taskId: regularTasksList[index].id,
                                  updateItems: () => updateGoals());
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

class RegularTaskActionButton extends StatelessWidget {
  const RegularTaskActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}