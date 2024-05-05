import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifebeat/components/surface.dart';
import 'package:lifebeat/entities/checkpoint.dart';
import 'package:lifebeat/main.dart';
import 'package:lifebeat/utils/task_funcs.dart';
import '../entities/goal.dart';

class GoalDetails extends StatefulWidget {
  const GoalDetails({
    super.key,
    required this.goalId,
  });

  final int goalId;

  @override
  State<GoalDetails> createState() => _GoalDetailsState();
}

class _GoalDetailsState extends State<GoalDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<Goal>(
            stream: objectbox.getGoal(widget.goalId),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                Goal goal = snapshot.data!;

                Row actions() {
                  return Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            goal.checkpoints.add(
                              Checkpoint(text: 'Тест')
                            );
                          });
                          objectbox.updateGoal(goal);
                        },
                        child: const Icon(CupertinoIcons.add),
                      )
                    ],
                  );
                }

                Expanded checkpointsList() {
                  return Expanded(
                    child: ListView.separated(
                      itemCount: goal.checkpoints.length,
                      itemBuilder: (context, index) => Row(
                        key: Key("checkpoint-${goal.checkpoints[index].id}"),
                        children: [
                          Checkbox(
                            value: goal.checkpoints[index].finished,
                            onChanged: (value) {
                              setState(() {
                                goal.checkpoints[index].finished = value ?? false;
                              });
                              objectbox.updateCheckpoint(goal.checkpoints[index]);
                            },
                          ),
                          Expanded(
                            child: Text(goal.checkpoints[index].text)
                          ),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () {},
                                child: const Text('Изменить'),
                              ),
                              PopupMenuItem(
                                onTap: () => setState(() =>
                                  objectbox.deleteCheckpoint(
                                    goal.checkpoints[index].id
                                  )
                                ),
                                child: const Text('Удалить'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      separatorBuilder: (context, index) => const SizedBox(height: 14),
                    ),
                  );
                }

                Surface valueAndDate() {
                  return Surface(
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 52,
                              width: 52,
                              child: CircularProgressIndicator(
                                strokeWidth: 5,
                                strokeAlign: -1,
                                value: 1,
                              ),
                            ),
                            Text('100%'),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.timer_rounded),
                                const SizedBox(width: 3),
                                Text("${DateTime.now().difference(goal.deadline).inDays} дней")
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month_rounded),
                                const SizedBox(width: 3),
                                Text("${TaskFuncs.ymdDate(goal.begin)} - ${TaskFuncs.ymdDate(goal.deadline)}")
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }

                Row topBar() {
                  return Row(
                    children: [
                      const BackButton(),
                      Expanded(
                        child: Text(goal.text),
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () {},
                            child: const Text('Изменить'),
                          ),
                          PopupMenuItem(
                            onTap: () {},
                            child: const Text('Удалить'),
                          ),
                        ],
                      )
                    ],
                  );
                }

                return Column(
                  children: [
                    topBar(),
                    const SizedBox(height: 20),
                    valueAndDate(),
                    const SizedBox(height: 20),
                    if (goal.description != '')
                      Row(
                        children: [
                          Expanded(
                            child: Surface(
                              child: Text(goal.description),
                            ),
                          ),
                        ],
                      ),
                    if (goal.description != '')
                      const SizedBox(height: 20),
                    actions(),
                    const SizedBox(height: 20),
                    checkpointsList(),
                  ],
                );
              } else {
                return const Center(child: Text("Цели не существует"));
              }
            }
          ),
        ),
      ),
    );
  }
}