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