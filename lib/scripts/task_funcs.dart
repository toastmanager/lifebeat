String readableDateTime(DateTime time) {
  int hourValue = time.hour;
  int minuteValue = time.minute;
  String hour =
      hourValue.toString().length > 1 ? hourValue.toString() : "0$hourValue";
  String minute = minuteValue.toString().length > 1
      ? minuteValue.toString()
      : "0$minuteValue";
  return '${time.year}-${time.month}-${time.day} $hour:$minute';
}
