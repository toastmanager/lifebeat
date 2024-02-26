import 'package:flutter/material.dart';
import 'package:lifebeat/models/regular_task_model.dart';
import 'package:lifebeat/pages/regular_task_details.dart';
import 'package:lifebeat/scripts/database/database.dart';
import 'package:lifebeat/scripts/vars.dart';

class RegularTask extends StatefulWidget {
  const RegularTask({super.key, required this.taskId, required this.updateItems});

  final int taskId;
  final Function() updateItems;

  @override
  State<RegularTask> createState() => _RegularTaskState();
}

class _RegularTaskState extends State<RegularTask> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RegularTaskModel>(
        future: DBHelper.getRegularTaskById(widget.taskId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            RegularTaskModel model = snapshot.data!;
            String name = model.name;
            String startTime = model.startTime;
            String endTime = model.endTime;

            void updateTaskComponent() async {
              model = await DBHelper.getRegularTaskById(widget.taskId);
              setState(() {});
            }

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => RegularTaskDetailsPage(
                              taskId: widget.taskId,
                              updateItemComponent: () => updateTaskComponent(),
                              updateItems: widget.updateItems,
                            )))
                    .then((value) => setState(() {}));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.grayBlueLight,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              name,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer_rounded,
                                  color: AppColors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.calendar_month_rounded,
                                  size: 16,
                                  color: AppColors.white,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '$startTime - $endTime',
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Text('Данные отсутствуют');
          }
        });
  }
}
