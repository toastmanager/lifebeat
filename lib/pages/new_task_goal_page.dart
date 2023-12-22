import 'package:flutter/material.dart';
import 'package:lifebeat/scripts/database/database.dart';
import 'package:lifebeat/scripts/task_funcs.dart';
import 'package:lifebeat/scripts/vars.dart';

InputDecoration decoration(String labelText) {
  return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      labelText: labelText);
}

class NewItemPage extends StatelessWidget {
  NewItemPage({super.key, this.gap = 20});

  final double gap;
  final name = TextEditingController();
  final description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          heading(context, 'New item'),
          SizedBox(height: gap),
          defaultInputs(gap),
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
        TextField(controller: name, decoration: decoration('Название')),
        SizedBox(height: gap),
        TextField(controller: description, decoration: decoration('Описание')),
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
      {super.key, required this.onDateSelected, required this.labelText});

  final Function(DateTime) onDateSelected;
  final String labelText;

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  var date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var dateController = TextEditingController(text: readableDate(date));
    return TextField(
      decoration: decoration(widget.labelText),
      readOnly: true,
      onTap: () async {
        date = await selectDate(context, date);
        widget.onDateSelected(date);
        setState(() {
          dateController = TextEditingController(text: readableDate(date));
        });
      },
      controller: dateController,
    );
  }
}

class NewGoalPage extends NewItemPage {
  NewGoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    var deadline = DateTime.now();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          heading(context, 'Новая цель'),
          SizedBox(height: gap),
          defaultInputs(gap),
          SizedBox(height: gap),
          DateField(
              labelText: 'Дедлайн', onDateSelected: (date) => deadline = date),
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
