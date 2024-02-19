import 'package:flutter/material.dart';
import 'package:lifebeat/scripts/database/database.dart';
import 'package:lifebeat/scripts/task_funcs.dart';
import 'package:lifebeat/scripts/vars.dart';

import '../styles/text_field_style.dart';

class NewItemPage extends StatefulWidget {
  NewItemPage({super.key, this.gap = 20});

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
          text: 'Отмена',
        )),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: NewItemButton(
          action: createAction,
          text: 'Создать',
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
        Text(text, style: AppTexts.headingBold),
      ],
    );
  }

  Column defaultInputs(double gap) {
    return Column(
      children: [
        TextField(controller: name, decoration: textFieldDecoration('Название')),
        SizedBox(height: gap),
        TextField(controller: description, decoration: textFieldDecoration('Описание')),
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
  NewTaskPage({super.key, this.optionalStartTime, this.optionalEndTime});

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
          heading(context, 'Новая задача'),
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
            labelText: 'Начало',
            initDate: startTime,
            date: startTime,
          ),
          SizedBox(height: gap),
          DateTimeField(
            onDateSelected: (date) {
              endTime = date;
              setState(() {});
            },
            labelText: 'Конец',
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
