import 'package:flutter_test/flutter_test.dart';
import 'package:lifebeat/models/goal_model.dart';
import 'package:lifebeat/models/regular_task_model.dart';
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

  test('Regular task with one week day should be added', () async {
    await DBHelper.addRegularTask('name', 'description', '00:00', '01:00',
        weekDays: ['monday']);
    RegularTaskModel regularTask = (await DBHelper.regularTasks())[0];
    expect(regularTask.id, 0);
    expect(regularTask.name, 'name');
    expect(regularTask.description, 'description');
    expect(regularTask.startTime, '00:00');
    expect(regularTask.endTime, '01:00');
    expect(regularTask.isWeekDays, true);
    expect(regularTask.weekDays, ['monday']);
    expect(regularTask.isIntervallic, false);
    expect(regularTask.interval, null);
    expect(regularTask.checkpoints, []);
  });

  test('Regular task with two week days should be added', () async {
    await DBHelper.addRegularTask('name', 'description', '00:00', '01:00',
        weekDays: ['monday', 'tuesday']);
    RegularTaskModel regularTask = (await DBHelper.regularTasks())[0];
    expect(regularTask.id, 0);
    expect(regularTask.name, 'name');
    expect(regularTask.description, 'description');
    expect(regularTask.startTime, '00:00');
    expect(regularTask.endTime, '01:00');
    expect(regularTask.isWeekDays, true);
    expect(regularTask.weekDays, ['monday', 'tuesday']);
    expect(regularTask.isIntervallic, false);
    expect(regularTask.interval, null);
    expect(regularTask.checkpoints, []);
  });

  test('Regular task with interval should be added', () async {
    var interval = const Duration(days: 2);
    await DBHelper.addRegularTask('name', 'description', '00:00', '01:00',
        interval: interval);
    RegularTaskModel regularTask = (await DBHelper.regularTasks())[0];
    expect(regularTask.id, 0);
    expect(regularTask.name, 'name');
    expect(regularTask.description, 'description');
    expect(regularTask.startTime, '00:00');
    expect(regularTask.endTime, '01:00');
    expect(regularTask.isWeekDays, false);
    expect(regularTask.weekDays, null);
    expect(regularTask.isIntervallic, true);
    expect(regularTask.interval, interval);
    expect(regularTask.checkpoints, []);
  });

  test('Regular task with incorrect startTime should throw error', () async {
    expect(
        () async => await DBHelper.addRegularTask(
            'name', 'description', '24:60', '19:26',
            weekDays: ['monday']),
        throwsException);
  });

  test('Regular task with incorrect endTime should throw error', () async {
    expect(
        () async => await DBHelper.addRegularTask(
            'name', 'description', '19:26', '24:60',
            weekDays: ['monday']),
        throwsException);
  });

  test('Regular task with empty weekDays and interval should throw error',
      () async {
    expect(
        () async => await DBHelper.insertRegularTask(RegularTaskModel(
            id: 0,
            name: 'name',
            description: 'description',
            startTime: '00:00',
            endTime: '01:00',
            checkpoints: [])),
        throwsException);
  });

  tearDownAll(() async {
    databaseFactory.deleteDatabase(join(await getDatabasesPath(), 'test.db'));
  });
}
