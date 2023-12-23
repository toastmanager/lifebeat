import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

String readableDateTime(DateTime time) {
  return '${time.year}-${time.month}-${time.day} ${readableTime(time.hour, time.minute)}';
}

String readableDate(DateTime time) {
  return '${time.year}-${time.month}-${time.day}';
}

String readableTime(int hourValue, int minuteValue) {
  String hour =
      hourValue.toString().length > 1 ? hourValue.toString() : "0$hourValue";
  String minute = minuteValue.toString().length > 1
      ? minuteValue.toString()
      : "0$minuteValue";
  return '$hour:$minute';
}

Future<DateTime> selectDate(BuildContext context, DateTime selectedDate) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101));
  return picked ?? selectedDate;
}

Future<DateTime?> taskDatePicker(
        BuildContext context, DateTime initialTime, Function(DateTime) action) =>
    DatePicker.showDateTimePicker(context,
        minTime: DateTime(2015, 8),
        maxTime: DateTime(2101),
        currentTime: initialTime,
        locale: LocaleType.ru,
        onConfirm: (date) => action(date));
