import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:lifebeat/utils/database/database.dart';
import 'package:lifebeat/utils/task_funcs.dart';
import 'package:lifebeat/utils/text_values.dart';
import 'package:lifebeat/utils/vars.dart';

Future<void> newItemMenu(BuildContext context, DateTime currentDay,
    {DateTime? optionalStartTime, DateTime? optionalEndTime}) {
  DateTime startTime = optionalStartTime ?? currentDay;
  DateTime endTime = optionalEndTime ?? currentDay;
  String startTimeText = readableDateTime(startTime);
  String endTimeText = readableDateTime(endTime);
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

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
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setLocalState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  TextValue.newTaskHeading,
                ),
                const SizedBox(height: 20),
                Flexible(
                    child: TextField(
                  controller: name,
                  decoration: const InputDecoration(
                      hintText: TextValue.newTaskName, border: OutlineInputBorder()),
                )),
                const SizedBox(height: 20),
                TextField(
                  controller: description,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      hintText: TextValue.newTaskDesk, border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: InkWell(
                    onTap: () async {
                      await taskDatePicker(
                          startTime,
                          (DateTime date) => setLocalState(() {
                                if (endTime == startTime) {
                                  endTime = date;
                                  endTimeText = readableDateTime(endTime);
                                }
                                startTime = date;
                                startTimeText = readableDateTime(startTime);
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
                                endTimeText = readableDateTime(endTime);
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
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Назад')),
                    ElevatedButton(
                        onPressed: () async {
                          await DBHelper.addTask(
                            name.text,
                            description.text,
                            startTime,
                            endTime,
                          );
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
