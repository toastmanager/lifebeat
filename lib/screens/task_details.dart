import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:lifebeat/components/item_description.dart';
import 'package:lifebeat/components/progress_circle.dart';
import 'package:lifebeat/models/checkpoint_model.dart';
import 'package:lifebeat/models/task_model.dart';
import 'package:lifebeat/utils/database/database.dart';
import 'package:lifebeat/utils/task_funcs.dart';
import 'package:lifebeat/utils/text_values.dart';
import 'package:lifebeat/utils/vars.dart';

class DetailsButton extends StatelessWidget {
  DetailsButton({
    super.key,
    required this.child,
    required this.action,
    this.color = AppColors.grayBlueLight,
  });

  final Widget child;
  final Function() action;
  final BorderRadius buttonBorderRadius = BorderRadius.circular(8);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: InkWell(
        onTap: () => action(),
        borderRadius: buttonBorderRadius,
        child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: buttonBorderRadius,
            ),
            height: 40,
            child: Center(child: child)),
      ),
    );
  }
}

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({
    super.key,
    required this.taskId,
    required this.updateItemComponent,
    required this.updateItems,
  });

  final int taskId;
  final Function() updateItemComponent;
  final Function() updateItems;
  Future<int> removeItem() => DBHelper.removeTask(taskId);

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  bool isEditMode = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _timer = Timer.periodic(
          const Duration(minutes: 1), (timer) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DBHelper.getTaskById(widget.taskId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            TaskModel model = snapshot.data!;
            String name = model.name;
            String description = model.description;
            double progress = model.progress;
            String timeLeft = model.timeLeft;
            DateTime startTime = model.startTime;
            DateTime endTime = model.endTime;
            List<CheckpointModel> checkpointsList = model.checkpoints;

            Future<void> editTaskMenu(
              BuildContext context,
            ) {
              DateTime startTime = model.startTime;
              DateTime endTime = model.endTime;
              String startTimeText = readableDateTime(startTime);
              String endTimeText = readableDateTime(endTime);
              TextEditingController name =
                  TextEditingController(text: model.name);
              TextEditingController description =
                  TextEditingController(text: model.description);

              Future<DateTime?> taskDatePicker(
                      DateTime initialTime, Function(DateTime) action) =>
                  DatePicker.showDateTimePicker(context,
                      minTime: DateTime(2015, 8),
                      maxTime: DateTime(2101),
                      currentTime: initialTime,
                      locale: LocaleType.ru,
                      onConfirm: (date) => action(date));

              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      backgroundColor: AppColors.grayBlueDark,
                      content: StatefulBuilder(builder:
                          (BuildContext context, StateSetter setLocalState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Изменить задачу',
                            ),
                            const SizedBox(height: 20),
                            Flexible(
                                child: TextField(
                              controller: name,
                              decoration: const InputDecoration(
                                  hintText: TextValue.name,
                                  border: OutlineInputBorder()),
                            )),
                            const SizedBox(height: 20),
                            TextField(
                              controller: description,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                  hintText: TextValue.description,
                                  border: OutlineInputBorder()),
                            ),
                            const SizedBox(height: 20),
                            Flexible(
                              child: InkWell(
                                onTap: () async {
                                  await taskDatePicker(
                                      startTime,
                                      (DateTime date) => setLocalState(() {
                                            Duration difference =
                                                endTime.difference(startTime);
                                            startTime = date;
                                            startTimeText =
                                                readableDateTime(startTime);
                                            // if (difference.inMinutes)
                                            endTime = startTime.add(difference);
                                            endTimeText =
                                                readableDateTime(endTime);
                                          }));
                                },
                                child: Text(startTimeText),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Flexible(
                              child: InkWell(
                                onTap: () async {
                                  await taskDatePicker(
                                      endTime,
                                      (date) => setLocalState(() {
                                            endTime = date;
                                            endTimeText =
                                                readableDateTime(endTime);
                                          }));
                                },
                                child: Text(endTimeText),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Назад')),
                                ElevatedButton(
                                    onPressed: () async {
                                      TaskModel newModel = TaskModel(
                                          id: model.id,
                                          completed: model.completed,
                                          name: name.text,
                                          description: description.text,
                                          startTime: startTime,
                                          endTime: endTime,
                                          checkpoints: model.checkpoints);
                                      await DBHelper.insertTask(newModel);
                                      setState(() {});
                                      if (mounted) {
                                        Navigator.of(context).pop();
                                      }
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
                checkpointsList.removeAt(checkpointsList
                    .indexWhere((element) => element.id == checkpointId));
              });
              await DBHelper.removeCheckpoint(
                  checkpointId, model.id, ItemType.task);
            }

            Row itemHeading(context) {
              return Row(
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
                            name,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                      onSelected: (item) async {
                        switch (item) {
                          case 0:
                            await widget.removeItem();
                            await widget.updateItems();
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                            break;
                          case 1:
                            editTaskMenu(context);
                        }
                      },
                      itemBuilder: (context) => [
                            const PopupMenuItem<int>(
                                value: 0, child: Text('Удалить')),
                            const PopupMenuItem<int>(
                                value: 1, child: Text('Изменить')),
                          ]),
                ],
              );
            }

            Column itemInfo() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ProgressCircle(progress: progress),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.timer_rounded,
                        color: AppColors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        timeLeft,
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.calendar_month_rounded,
                        size: 16,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${readableTime(startTime.hour, startTime.minute)} - ${readableTime(endTime.hour, endTime.minute)}',
                      ),
                    ],
                  ),
                  ItemDescription(description: description)
                ],
              );
            }

            Container horizontalDivider() {
              return Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grayBlueLight,
                  borderRadius: BorderRadius.circular(9),
                ),
              );
            }

            Future<void> newCheckpointMenu(BuildContext checkpointMenuContext) {
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
                              hintText: 'Чекпоинт',
                              border: OutlineInputBorder()),
                        )),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              child: const Text('отмена'),
                              onPressed: () =>
                                  Navigator.of(checkpointMenuContext).pop(),
                            ),
                            ElevatedButton(
                              child: const Text('добавить'),
                              onPressed: () async {
                                await DBHelper.addCheckpoint(
                                    false,
                                    newCheckpointname.text,
                                    widget.taskId,
                                    ItemType.task);
                                model =
                                    await DBHelper.getTaskById(widget.taskId);
                                setState(() {});
                                widget.updateItemComponent();
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

            Row itemActions() {
              return Row(
                children: [
                  if (!isEditMode)
                    DetailsButton(
                      child: const Icon(
                        Icons.edit_rounded,
                        color: AppColors.white,
                        size: 16,
                      ),
                      action: () => switchEditMode(),
                    ),
                  if (isEditMode)
                    DetailsButton(
                      color: AppColors.accentBlue,
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
                    action: () => newCheckpointMenu(context),
                  ),
                ],
              );
            }

            Widget checkpointWidget(CheckpointModel checkpoint) {
              return Row(
                children: [
                  Checkbox(
                    value: checkpoint.value,
                    onChanged: (value) async {
                      setState(() {
                        checkpoint.value =
                            checkpoint.value == true ? false : true;
                        DBHelper.insertCheckpoint(
                            checkpoint, widget.taskId, ItemType.task);
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

            Flexible checkpointsListWidget() {
              Widget checkpoint(int index) {
                return Column(
                  key: Key("${checkpointsList[index].id}"),
                  children: [
                    checkpointWidget(checkpointsList[index]),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                );
              }

              return Flexible(
                  child: ReorderableListView(
                buildDefaultDragHandles: false,
                onReorder: (oldIndex, newIndex) async {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final CheckpointModel item =
                        checkpointsList.removeAt(oldIndex);
                    checkpointsList.insert(newIndex, item);
                  });
                  model.checkpoints = checkpointsList;
                  await DBHelper.insertTask(model);
                },
                children: [
                  if (isEditMode)
                    for (var index = 0; index < checkpointsList.length; index++)
                      ReorderableDragStartListener(
                          key: Key("${checkpointsList[index].id}"),
                          index: index,
                          child: checkpoint(index)),
                  if (!isEditMode)
                    for (var index = 0; index < checkpointsList.length; index++)
                      checkpoint(index)
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
                        itemHeading(context),
                        const SizedBox(height: 20),
                        itemInfo(),
                        const SizedBox(height: 20),
                        horizontalDivider(),
                        const SizedBox(height: 20),
                        itemActions(),
                        const SizedBox(height: 20),
                        checkpointsListWidget(),
                      ],
                    )),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
