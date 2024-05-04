import 'package:shared_preferences/shared_preferences.dart';

final class Settings {
  static late final SharedPreferences prefs;

  static String afternoonBeginTimeKey = 'afternoonBeginTime';
  static String eveningBeginTimeKey = 'eveningBeginTime';

  static Future init() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getInt(afternoonBeginTimeKey) == null) {
      prefs.setInt(afternoonBeginTimeKey, defaultAfternoonBeginTime);
    }

    if (prefs.getInt(eveningBeginTimeKey) == null) {
      prefs.setInt(eveningBeginTimeKey, defaultEveningBeginTime);
    }
  }

  static int defaultAfternoonBeginTime = 780;
  static int defaultEveningBeginTime = 1020;
  static int afternoonBeginTime = prefs.getInt(afternoonBeginTimeKey)!;
  static int eveningBeginTime = prefs.getInt(eveningBeginTimeKey)!;
}