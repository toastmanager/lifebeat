import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:lifebeat/models/goal_model.dart';

class DBHelper {
  static Future<Database> database() async {
    final path = join(await getDatabasesPath(), 'database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS goals(id INTEGER PRIMARY KEY, completed BOOL, progress FLOAT, daysLeft INT, name TEXT, description TEXT, deadline TEXT)',
        );
      },
    );
  }
}