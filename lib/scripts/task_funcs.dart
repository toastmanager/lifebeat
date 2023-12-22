import 'package:flutter/material.dart';

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

Future<DateTime> selectDate(
      BuildContext context, DateTime selectedDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    return picked ?? selectedDate;
  }