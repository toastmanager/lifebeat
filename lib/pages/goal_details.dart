import 'package:flutter/material.dart';
import 'package:lifebeat/components/progress_circle.dart';
import 'package:lifebeat/models/checkpoint_model.dart';
import 'package:lifebeat/scripts/database/database.dart';
import 'package:lifebeat/scripts/vars.dart';
import 'package:lifebeat/models/goal_model.dart';

class DetailsButton extends StatelessWidget {
  DetailsButton({
    super.key,
    required this.child,
    required this.action,
  });

  final Widget child;
  final Function action;
  final BorderRadius buttonBorderRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: InkWell(
        onTap: () => action(),
        borderRadius: buttonBorderRadius,
        child: Container(
            decoration: BoxDecoration(
              color: AppColors.grayBlueLight,
              borderRadius: buttonBorderRadius,
            ),
            height: 40,
            child: Center(child: child)),
      ),
    );
  }
}

class GoalDetailsPage extends StatefulWidget {
  GoalDetailsPage(
      {super.key,
      required this.model,
      required this.updateGoalComponent,
      required this.updateGoals});

  GoalModel model;
  final Function updateGoalComponent;
  final Function updateGoals;

  @override
  State<GoalDetailsPage> createState() => _GoalDetailsPageState();
}

class _GoalDetailsPageState extends State<GoalDetailsPage> {
  @override
  Widget build(BuildContext context) {
    GoalModel model = widget.model;
    int timeLeft = model.deadline.difference(DateTime.now()).inDays;

    Widget checkpointWidget(CheckpointModel checkpoint) {
      return Row(
        children: [
          Checkbox(
            value: checkpoint.value,
            onChanged: (value) async {
              setState(() {
                checkpoint.value = checkpoint.value == true ? false : true;
                DBHelper.insertGoal(model);
                model.progress = model.getProgress();
              });
            },
          ),
          Expanded(
            child: Text(
              checkpoint.text,
              style: AppTexts.body,
            ),
          ),
        ],
      );
    }

    Widget checkpointsList() {
      List<CheckpointModel> checkpointsList = model.checkpoints;
      return Flexible(
          child: ReorderableListView(
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) async {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final CheckpointModel item = checkpointsList.removeAt(oldIndex);
            checkpointsList.insert(newIndex, item);
          });
          model.checkpoints = checkpointsList;
          await DBHelper.insertGoal(model);
        },
        children: [
          for (var index = 0; index < checkpointsList.length; index++)
            ReorderableDragStartListener(
                key: Key("${checkpointsList[index].id}"),
                index: index,
                child: Column(
                  children: [
                    checkpointWidget(checkpointsList[index]),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                )),
        ],
      ));
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: AppColors.white,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            model.name,
                            style: AppTexts.headingBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                      onSelected: (item) async {
                        switch (item) {
                          case 0:
                            await DBHelper.removeGoal(model.id);
                            await widget.updateGoals();
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                            break;
                          case 1:
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                            const PopupMenuItem<int>(
                                value: 0, child: Text('Удалить'))
                          ]),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ProgressCircle(progress: model.progress),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.timer_rounded,
                    color: AppColors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '$timeLeft дней',
                    style: AppTexts.body,
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.calendar_month_rounded,
                    size: 16,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${model.deadline.day}.${model.deadline.month}.${model.deadline.year}',
                    style: AppTexts.body,
                  ),
                ],
              ),
              if (model.description.isNotEmpty) const SizedBox(height: 20),
              if (model.description.isNotEmpty)
                Text(
                  model.description,
                  style: AppTexts.body,
                ),
              const SizedBox(height: 20),
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grayBlueLight,
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  DetailsButton(
                    child: const Icon(
                      Icons.edit_rounded,
                      color: AppColors.white,
                      size: 16,
                    ),
                    action: () {},
                  ),
                  const SizedBox(width: 10),
                  DetailsButton(
                    child: Text(
                      '+',
                      style: AppTexts.bodyBold,
                    ),
                    action: () => _newCheckpointMenu(context),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              checkpointsList(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _newCheckpointMenu(BuildContext checkpointMenuContext) {
    TextEditingController newCheckpointname = TextEditingController();

    return showDialog(
      context: context,
      builder: (checkpointMenuContext) {
        return AlertDialog(
          backgroundColor: AppColors.grayBlueDark,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Новый чекпоинт', style: AppTexts.bodyBold),
              const SizedBox(
                height: 20,
              ),
              Flexible(
                  child: TextField(
                controller: newCheckpointname,
                decoration: const InputDecoration(
                    hintText: 'Чекпоинт', border: OutlineInputBorder()),
              )),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ElevatedButton(
                    child: const Text('отмена'),
                    onPressed: () => Navigator.of(checkpointMenuContext).pop(),
                  ),
                  ElevatedButton(
                    child: const Text('добавить'),
                    onPressed: () async {
                      await DBHelper.addCheckpoint(
                          false,
                          newCheckpointname.text,
                          widget.model.id,
                          ItemType.goal);
                      List<GoalModel> goalsList = await DBHelper.goals();
                      setState(() {
                        widget.model = goalsList.firstWhere(
                            (element) => element.id == widget.model.id);
                      });
                      widget.updateGoalComponent(widget.model);
                      if (mounted) {
                        Navigator.of(checkpointMenuContext).pop();
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
