import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

abstract final class Settings {
  static late SharedPreferences prefs;
  static late String defaultDBPath;

  // Make sure you initialize Settings when running app
  static Future init() async {
    prefs = await SharedPreferences.getInstance();
    defaultDBPath = join(await getDatabasesPath(), 'database.db');

    if (prefs.getString('init_page') == null) {
      prefs.setString('init_page', '/schedule');
    }

    if (prefs.getString('db_path') == null) {
      prefs.setString('db_path', defaultDBPath);
    }
  }

  static void reset() {
    prefs.clear();
    init();
  }

  static void setInitPage(String page) {
    prefs.setString('init_page', page);
  }

  static void setDBPath(String page) {
    prefs.setString('db_path', page);
  }

  static String initPage = prefs.getString('init_page') ?? '/schedule';
  static String dbPath = prefs.getString('db_path') ?? defaultDBPath;
}
