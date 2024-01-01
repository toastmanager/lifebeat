import 'package:flutter_test/flutter_test.dart';
import 'package:lifebeat/models/goal_model.dart';
import 'package:lifebeat/scripts/database/database.dart';
import 'package:lifebeat/scripts/settings.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late String dbPath;
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  setUpAll(() async {
    dbPath = join(await getDatabasesPath(), 'test.db');
    SharedPreferences.setMockInitialValues({'db_path': dbPath});
    await Settings.init();
  });

  setUp(() => databaseFactory.deleteDatabase(dbPath));

  test('Goal should be added', () async {
    await DBHelper.addGoal('name', 'description', DateTime(2023));
    GoalModel goal = (await DBHelper.goals())[0];
    expect(goal.id, 0);
    expect(goal.completed, false);
    expect(goal.name, 'name');
    expect(goal.description, 'description');
    expect(goal.deadline, DateTime(2023));
    expect(goal.checkpoints, []);
  });

  tearDownAll(() async {
    databaseFactory.deleteDatabase(join(await getDatabasesPath(), 'test.db'));
  });
}
