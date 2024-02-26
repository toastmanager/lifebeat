import 'package:flutter/material.dart';
import 'package:lifebeat/components/horizontal_divider.dart';
import 'package:lifebeat/scripts/database/database.dart';
import 'package:lifebeat/scripts/regular_task_funcs.dart';
import 'package:lifebeat/scripts/task_funcs.dart';
import 'package:lifebeat/scripts/text.dart';
import 'package:lifebeat/scripts/vars.dart';

import '../styles/text_field_style.dart';

class NewItemPage extends StatefulWidget {
  const NewItemPage({super.key, this.gap = 20});

  final double gap;

  @override
  State<NewItemPage> createState() => _NewItemPageState();
}

class _NewItemPageState<T extends NewItemPage> extends State<T> {
  final name = TextEditingController();
  final description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          heading(context, 'New item'),
          SizedBox(height: widget.gap),
          defaultInputs(widget.gap),
          const Spacer(),
          buttons(context, () {})
        ],
      ),
    );
  }

  Row buttons(BuildContext context, Function() createAction) {
    return Row(
      children: [
        Expanded(
            child: NewItemButton(
          action: () => Navigator.pop(context),
          text: TextValue.cancel,
        )),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: NewItemButton(
          action: createAction,
          text: TextValue.continueText,
          backgroundColor: AppColors.purple,
        )),
      ],
    );
  }

  Row heading(BuildContext context, String text) {
    return Row(
      children: [
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_rounded)),
        const SizedBox(width: 10,),
        Expanded(child: Text(text)),
      ],
    );
  }

  Column defaultInputs(double gap) {
    return Column(
      children: [
        TextField(
            controller: name, decoration: textFieldDecoration(TextValue.name)),
        SizedBox(height: gap),
        TextField(
            controller: description,
            decoration: textFieldDecoration(TextValue.description)),
      ],
    );
  }
}

class NewItemButton extends StatelessWidget {
  const NewItemButton({
    super.key,
    required this.action,
    required this.text,
    this.backgroundColor = AppColors.grayBlueLight,
  });

  final Function() action;
  final String text;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(10, 50),
          backgroundColor: backgroundColor,
          foregroundColor: AppColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      child: Text(text),
    );
  }
}

class DateField extends StatefulWidget {
  const DateField(
      {super.key,
      required this.onDateSelected,
      required this.labelText,
      this.initDate});

  final Function(DateTime) onDateSelected;
  final String labelText;
  final DateTime? initDate;

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  var date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    date = widget.initDate ?? DateTime.now();
    var dateController = TextEditingController(text: readableDate(date));
    return TextField(
      decoration: textFieldDecoration(widget.labelText),
      readOnly: true,
      onTap: () async {
        date = await selectDate(context, date);
        setState(() {
          dateController = TextEditingController(text: readableDate(date));
        });
        widget.onDateSelected(date);
      },
      controller: dateController,
    );
  }
}

class DateTimeField extends StatefulWidget {
  const DateTimeField(
      {super.key,
      required this.onDateSelected,
      required this.labelText,
      this.date,
      this.initDate,
      this.controller});

  final Function(DateTime) onDateSelected;
  final String labelText;
  final DateTime? date;
  final DateTime? initDate;
  final TextEditingController? controller;

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  var date = DateTime.now();
  var isChanged = false;
  @override
  Widget build(BuildContext context) {
    date = widget.date ?? (isChanged ? date : widget.initDate ?? date);
    isChanged = true;
    var dateController = TextEditingController(text: readableDateTime(date));
    if (widget.controller != null) {
      dateController = widget.controller!;
    }
    return TextField(
      decoration: textFieldDecoration(widget.labelText),
      readOnly: true,
      onTap: () async {
        date = await taskDatePicker(context, date, (date) {}) ?? date;
        widget.onDateSelected(date);
        setState(() {
          dateController = TextEditingController(text: readableDateTime(date));
        });
      },
      controller: dateController,
    );
  }
}

class NewGoalPage extends NewItemPage {
  NewGoalPage({super.key});

  @override
  State<NewItemPage> createState() => _NewGoalPageState();
}

class _NewGoalPageState extends _NewItemPageState {
  var deadline = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var gap = widget.gap;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          heading(context, 'Новая цель'),
          SizedBox(height: gap),
          defaultInputs(gap),
          SizedBox(height: gap),
          DateField(
              labelText: 'Дедлайн',
              initDate: deadline,
              onDateSelected: (date) {
                deadline = date;
                setState(() {});
              }),
          const Spacer(),
          buttons(context, () async {
            await DBHelper.addGoal(
              name.text,
              description.text,
              deadline,
            );
            Navigator.of(context).pop();
          })
        ],
      ),
    );
  }
}

class NewTaskPage extends NewItemPage {
  const NewTaskPage({super.key, this.optionalStartTime, this.optionalEndTime});

  final DateTime? optionalStartTime;
  final DateTime? optionalEndTime;

  @override
  State<NewItemPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends _NewItemPageState<NewTaskPage> {
  DateTime? startTime;
  DateTime? endTime;

  @override
  Widget build(BuildContext context) {
    startTime = startTime ?? widget.optionalStartTime ?? DateTime.now();
    endTime = endTime ?? widget.optionalEndTime ?? DateTime.now();
    var startTimeController =
        TextEditingController(text: readableDateTime(startTime!));
    var endTimeController =
        TextEditingController(text: readableDateTime(endTime!));
    var gap = widget.gap;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          heading(context, TextValue.newTaskHeading),
          SizedBox(height: gap),
          defaultInputs(gap),
          SizedBox(height: gap),
          DateTimeField(
            onDateSelected: (date) {
              Duration difference = endTime!.difference(startTime!);
              startTime = date;
              endTime = startTime!.add(difference);
              setState(() {});
            },
            controller: startTimeController,
            labelText: TextValue.newTaskStart,
            initDate: startTime,
            date: startTime,
          ),
          SizedBox(height: gap),
          DateTimeField(
            onDateSelected: (date) {
              endTime = date;
              setState(() {});
            },
            labelText: TextValue.newTaskEnd,
            initDate: endTime,
            date: endTime,
            controller: endTimeController,
          ),
          const Spacer(),
          buttons(context, () async {
            await DBHelper.addTask(
              name.text,
              description.text,
              startTime!,
              endTime!,
            );
            Navigator.of(context).pop();
          })
        ],
      ),
    );
  }
}

class NewRegularTaskPage extends NewItemPage {
  NewRegularTaskPage({super.key, this.optionalStartTime, this.optionalEndTime});

  final DateTime? optionalStartTime;
  final DateTime? optionalEndTime;

  @override
  State<NewItemPage> createState() => _NewRegularTaskPageState();
}

class _NewRegularTaskPageState extends _NewItemPageState<NewRegularTaskPage> {
  DateTime? startTime;
  DateTime? endTime;

  var timeFieldController = TextEditingController();
  List<String> weekDaysList = [];

  void addRegularTask(BuildContext context) async {
    await DBHelper.addRegularTask(name.text, description.text, timeFieldController.text.substring(0,5), timeFieldController.text.substring(8,13),
        weekDays: weekDaysList);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Row weekDaysButtons() {
    return Row(
      children: [
        WeekDayButton(weekDay: TextValue.mondayShort, onActive: () => weekDaysList.add(WeekDays.mon), onUnactive: () => weekDaysList.remove(WeekDays.mon)),
        const SizedBox(width: 10),
        WeekDayButton(weekDay: TextValue.tuesdayShort, onActive: () => weekDaysList.add(WeekDays.tue), onUnactive: () => weekDaysList.remove(WeekDays.tue)),
        const SizedBox(width: 10),
        WeekDayButton(weekDay: TextValue.wednesdayShort, onActive: () => weekDaysList.add(WeekDays.wed), onUnactive: () => weekDaysList.remove(WeekDays.wed)),
        const SizedBox(width: 10),
        WeekDayButton(weekDay: TextValue.thursdayShort, onActive: () => weekDaysList.add(WeekDays.thu), onUnactive: () => weekDaysList.remove(WeekDays.thu)),
        const SizedBox(width: 10),
        WeekDayButton(weekDay: TextValue.fridayShort, onActive: () => weekDaysList.add(WeekDays.fri), onUnactive: () => weekDaysList.remove(WeekDays.fri)),
        const SizedBox(width: 10),
        WeekDayButton(weekDay: TextValue.saturdayShort, onActive: () => weekDaysList.add(WeekDays.sat), onUnactive: () => weekDaysList.remove(WeekDays.sat)),
        const SizedBox(width: 10),
        WeekDayButton(weekDay: TextValue.sundayShort, onActive: () => weekDaysList.add(WeekDays.sun), onUnactive: () => weekDaysList.remove(WeekDays.sun)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          heading(context, 'Новая регулярная задача'),
          SizedBox(height: widget.gap),
          defaultInputs(widget.gap),
          SizedBox(height: widget.gap),
          TimeField(controller: timeFieldController,),
          SizedBox(height: widget.gap),
          const Row(
            children: [
              HorizontalDivider(),
            ],
          ),
          SizedBox(height: widget.gap),
          const Text('Повторять'),
          weekDaysButtons(),
          const Spacer(),
          buttons(context, () => addRegularTask(context)),
        ],
      ),
    );
  }
}

class WeekDayButton extends StatefulWidget {
  const WeekDayButton({super.key, required this.weekDay, required this.onActive, required this.onUnactive});

  final String weekDay;
  // final String value;
  final Function() onActive;
  final Function() onUnactive;

  @override
  State<WeekDayButton> createState() => _WeekDayButtonState();
}

class _WeekDayButtonState extends State<WeekDayButton> {
  bool isChoosed = false;
  Color color = AppColors.grayBlueLight;
  @override
  Widget build(BuildContext context) {
    void onTap() {
      if (!isChoosed) {
        setState(() {
          isChoosed = true;
          color = AppColors.purple;
          widget.onActive();
        });
      } else {
        setState(() {
          isChoosed = false;
          color = AppColors.grayBlueLight;
          widget.onUnactive();
        });
      }
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        child: Center(child: Text(widget.weekDay))
      ),
    );
  }
}

class TimeField extends StatelessWidget {
  const TimeField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: textFieldDecoration(TextValue.newRegularTaskExecutionTime, hintText: 'HH:MM - HH:MM'),
    );
  }
}