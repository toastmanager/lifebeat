import 'package:flutter/material.dart';

Future<DateTime> chooseDate(DateTime initDate, BuildContext context) async {
  DateTime? datetime = await showDatePicker(
    context: context,
    firstDate: DateTime(1960), 
    lastDate: DateTime(2200),
    locale: const Locale('ru', 'RU'),
    initialDate: initDate
  );
  return datetime ?? initDate;
}

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month &&
    date1.day == date2.day;
}