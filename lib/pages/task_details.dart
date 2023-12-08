import 'package:flutter/material.dart';
import 'package:lifebeat/components/progress_circle.dart';
import 'package:lifebeat/models/checkpoint_model.dart';
import 'package:lifebeat/models/task_model.dart';
import 'package:lifebeat/scripts/database/database.dart';
import 'package:lifebeat/scripts/task_funcs.dart';
import 'package:lifebeat/scripts/vars.dart';

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

            Row _itemHeading(context) {
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
                            Navigator.of(context).pop();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                            const PopupMenuItem<int>(
                                value: 0, child: Text('Удалить'))
                          ]),
                ],
              );
            }

            Column _itemInfo() {
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
                        '${readableTime(startTime.hour, startTime.minute)} - ${readableTime(endTime.hour, endTime.minute)}',
                        style: AppTexts.body,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    description,
                    style: AppTexts.body,
                  ),
                ],
              );
            }

            Container _horizontalDivider() {
              return Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grayBlueLight,
                  borderRadius: BorderRadius.circular(9),
                ),
              );
            }

            Future<void> _newCheckpointMenu(
                BuildContext checkpointMenuContext) {
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

            Row _itemAction() {
              return Row(
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
              );
            }

            Flexible _checkpointsList() {
              return Flexible(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Checkbox(
                              value: checkpointsList[index].value,
                              onChanged: (value) async {
                                setState(() {
                                  checkpointsList[index].value =
                                      checkpointsList[index].value == true
                                          ? false
                                          : true;
                                  DBHelper.insertCheckpoint(
                                      checkpointsList[index],
                                      widget.taskId,
                                      ItemType.task);
                                  model.progress = model.getProgress();
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                checkpointsList[index].text,
                                style: AppTexts.body,
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: checkpointsList.length));
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
                        _itemHeading(context),
                        const SizedBox(height: 20),
                        _itemInfo(),
                        const SizedBox(height: 20),
                        _horizontalDivider(),
                        const SizedBox(height: 20),
                        _itemAction(),
                        const SizedBox(height: 20),
                        _checkpointsList()
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
