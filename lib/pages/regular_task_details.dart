import 'dart:async';
import 'package:flutter/material.dart';

import 'package:lifebeat/components/horizontal_divider.dart';
import 'package:lifebeat/components/item_description.dart';
import 'package:lifebeat/models/checkpoint_model.dart';
import 'package:lifebeat/models/regular_task_model.dart';
import 'package:lifebeat/scripts/database/database.dart';
import 'package:lifebeat/scripts/vars.dart';

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

class RegularTaskDetailsPage extends StatefulWidget {
  const RegularTaskDetailsPage({
    super.key,
    required this.taskId,
    required this.updateItemComponent,
    required this.updateItems,
  });

  final int taskId;
  final Function() updateItemComponent;
  final Function() updateItems;
  Future removeItem() => DBHelper.removeRegularTask(taskId);

  @override
  State<RegularTaskDetailsPage> createState() => _RegularTaskDetailsPageState();
}

class _RegularTaskDetailsPageState extends State<RegularTaskDetailsPage> {
  bool isEditMode = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DBHelper.getRegularTaskById(widget.taskId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            RegularTaskModel model = snapshot.data!;
            String name = model.name;
            String description = model.description;
            String startTime = model.startTime;
            String endTime = model.endTime;
            List<CheckpointModel> checkpointsList = model.checkpoints;

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
                  checkpointId, model.id, ItemType.regularTask);
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
                            await widget.removeItem();
                            await widget.updateItems();
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                            break;
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
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.calendar_month_rounded,
                        size: 16,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '$startTime - $endTime',
                        style: AppTexts.body,
                      ),
                    ],
                  ),
                  ItemDescription(description: description)
                ],
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
                        Text('Новый чекпоинт', style: AppTexts.bodyBold),
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
                                    ItemType.regularTask);
                                model =
                                    await DBHelper.getRegularTaskById(widget.taskId);
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
                    child: Text(
                      '+',
                      style: AppTexts.bodyBold,
                    ),
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
                            checkpoint, widget.taskId, ItemType.regularTask);
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      checkpoint.text,
                      style: AppTexts.body,
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
                  await DBHelper.insertRegularTask(model);
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
                        const HorizontalDivider(),
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
