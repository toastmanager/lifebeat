String readableDateTime(DateTime time) {
  return '${time.year}-${time.month}-${time.day} ${readableTime(time.hour, time.minute)}';
}

String readableTime(int hourValue, int minuteValue) {
  String hour =
      hourValue.toString().length > 1 ? hourValue.toString() : "0$hourValue";
  String minute = minuteValue.toString().length > 1
      ? minuteValue.toString()
      : "0$minuteValue";
  return '$hour:$minute';
}
