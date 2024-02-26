import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifebeat/components/item_description.dart';
import 'package:lifebeat/components/progress_circle.dart';
import 'package:lifebeat/models/checkpoint_model.dart';
import 'package:lifebeat/utils/database/database.dart';
import 'package:lifebeat/utils/text_values.dart';
import 'package:lifebeat/utils/vars.dart';
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
  bool isEditMode = false;

  @override
  Widget build(BuildContext context) {
    GoalModel model = widget.model;
    int timeLeft = model.deadline.difference(DateTime.now()).inDays;

    void switchEditMode() {
      setState(() {
        if (isEditMode) {
          isEditMode = false;
        } else {
          isEditMode = true;
        }
      });
    }

    void deleteCheckpoint(int checkpointId) async {
      setState(() {
        widget.model.checkpoints.removeAt(widget.model.checkpoints
            .indexWhere((element) => element.id == checkpointId));
      });
      await DBHelper.removeCheckpoint(checkpointId, model.id, ItemType.goal);
    }

    Widget checkpointWidget(CheckpointModel checkpoint) {
      return Row(
        children: [
          Checkbox(
            value: checkpoint.value,
            onChanged: (value) async {
              setState(() {
                checkpoint.value = checkpoint.value == true ? false : true;
                DBHelper.insertCheckpoint(checkpoint, model.id, ItemType.goal);
                model.progress = model.getProgress();
              });
            },
          ),
          Expanded(
            child: Text(
              checkpoint.text,
            ),
          ),
          if (isEditMode)
            IconButton(
                onPressed: () => deleteCheckpoint(checkpoint.id),
                icon: const Icon(Icons.delete_rounded))
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

    Future<DateTime> selectDate(
        BuildContext context, DateTime selectedDate) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      return picked ?? selectedDate;
    }

    Future<void> editGoalMenu(BuildContext context) {
      DateTime deadline = widget.model.deadline;
      String deadlineText =
          '${deadline.year}-${deadline.month}-${deadline.day}';
      TextEditingController name =
          TextEditingController(text: widget.model.name);
      TextEditingController description =
          TextEditingController(text: widget.model.description);

      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: AppColors.grayBlueDark,
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setLocalState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      TextValue.changeGoal,
                    ),
                    const SizedBox(height: 20),
                    Flexible(
                        child: TextField(
                      controller: name,
                      decoration: const InputDecoration(
                          hintText: TextValue.name, border: OutlineInputBorder()),
                    )),
                    const SizedBox(height: 20),
                    TextField(
                      controller: description,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: TextValue.description, border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          deadline = await selectDate(context, deadline);
                          setLocalState(() {
                            deadlineText =
                                '${deadline.year}-${deadline.month}-${deadline.day}';
                          });
                        },
                        child: Text(deadlineText),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Назад')),
                        ElevatedButton(
                            onPressed: () async {
                              GoalModel newGoal = GoalModel(
                                  id: widget.model.id,
                                  completed: widget.model.completed,
                                  name: name.text,
                                  description: description.text,
                                  deadline: deadline,
                                  checkpoints: widget.model.checkpoints);
                              await DBHelper.insertGoal(newGoal);
                              setState(() {
                                widget.model = newGoal;
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('Продолжить')),
                      ],
                    ),
                  ],
                );
              }));
        },
      );
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
                            editGoalMenu(context);
                        }
                      },
                      itemBuilder: (context) => [
                            const PopupMenuItem<int>(
                                value: 0, child: Text('Удалить')),
                            const PopupMenuItem<int>(
                                value: 1, child: Text('Изменить')),
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
                  ),
                ],
              ),
              ItemDescription(description: widget.model.description),
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
                    action: () => switchEditMode(),
                  ),
                  const SizedBox(width: 10),
                  DetailsButton(
                    child: const Icon(CupertinoIcons.plus),
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
              Text('Новый чекпоинт'),
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
