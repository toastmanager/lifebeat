import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifebeat/components/lbtextfield.dart';
import 'package:lifebeat/components/surface.dart';
import 'package:lifebeat/entities/checkpoint.dart';
import 'package:lifebeat/main.dart';
import 'package:lifebeat/screens/goal_properties_page.dart';
import 'package:lifebeat/utils/task_funcs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                        onPressed: () async {
                          final newCheckpointname = TextEditingController();
                          await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AlertDialog(
                              title: Text(AppLocalizations.of(context)!.new_task),
                              content: LBTextField(
                                controller: newCheckpointname,
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    newCheckpointname.text = '';
                                    Navigator.pop(context);
                                  },
                                  child: Text(AppLocalizations.of(context)!.discard)
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(AppLocalizations.of(context)!.confirm)
                                ),
                              ],
                            ),
                          );
                          if (newCheckpointname.text != '') {
                            setState(() {
                              goal.checkpoints.add(
                                Checkpoint(text: newCheckpointname.text)
                              );
                            });
                            objectbox.updateGoal(goal);
                          }
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
                                child: Text(AppLocalizations.of(context)!.edit),
                              ),
                              PopupMenuItem(
                                onTap: () => setState(() =>
                                  objectbox.deleteCheckpoint(
                                    goal.checkpoints[index].id
                                  )
                                ),
                                child: Text(AppLocalizations.of(context)!.delete),
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
                                value: goal.doneCheckpoints(),
                                backgroundColor: Theme.of(context)
                                  .colorScheme.primary.withAlpha(127)
                              ),
                            ),
                            Text("${(goal.doneCheckpoints() * 100).toInt()}%"),
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
                                Text("${goal.deadline.difference(DateTime.now()).inDays} ${AppLocalizations.of(context)!.days}")
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
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => GoalPropertiesPage(
                                    goal: goal,
                                  ),
                                )
                              );
                              setState(() {});
                            },
                            child: Text(AppLocalizations.of(context)!.edit),
                          ),
                          PopupMenuItem(
                            onTap: () {
                              objectbox.deleteGoal(goal.id);
                              Navigator.of(context).pop();
                            },
                            child: Text(AppLocalizations.of(context)!.delete),
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
                return const Center(child: CircularProgressIndicator());
              }
            }
          ),
        ),
      ),
    );
  }
}