import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:lifebeat/models/goal_model.dart';

class DBHelper {
  static Future createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS goals(id INTEGER PRIMARY KEY, completed BOOL, progress FLOAT, daysLeft INT, name TEXT, description TEXT, deadline TEXT, checkpoints TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS checkpoints(id INTEGER PRIMARY KEY, value BOOL, text TEXT)');
  }

  static Future<Database> database() async {
    final path = join(await getDatabasesPath(), 'database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) => createDB(db, version),
    );
  }

  static Future<CheckpointModel> parseCheckpoint(int id) async {
    final db = await database();
    final List<Map<String, dynamic>> checkpointsMap =
        await db.query('checkpoints');

    final Map<String, dynamic> checkpoint =
        checkpointsMap.firstWhere((element) => element['id'] == id);

    return CheckpointModel(
      id: checkpoint['id'] as int,
      text: checkpoint['text'] as String,
      value: checkpoint['value'] as int == 1 ? true : false,
    );
  }

  static Future<GoalModel> parseGoal(int id) async {
    final db = await database();
    final List<Map<String, dynamic>> goalsMap = await db.query('goals');
    final Map<String, dynamic> goalMap =
        goalsMap.firstWhere((element) => element['id'] == id);

    DateTime deadline = DateTime.parse(goalMap['deadline'] as String);
    List<int> goalsCheckpoints =
        jsonDecode(goalMap['checkpoints']).cast<int>().toList();
    List<CheckpointModel> checkpoints = [];

    for (int j = 0; j < goalsCheckpoints.length; j++) {
      int checkpointId = goalsCheckpoints[j];
      checkpoints.add(await parseCheckpoint(checkpointId));
    }

    return GoalModel(
      id: goalMap['id'] as int,
      completed: goalMap['completed'] as int == 1 ? true : false,
      name: goalMap['name'] as String,
      description: goalMap['description'] as String,
      deadline: deadline,
      checkpoints: checkpoints,
    );
  }

  static Future<List<CheckpointModel>> checkpoints() async {
    final db = await database();
    final List<Map<String, dynamic>> checkpointsMap =
        await db.query('checkpoints');

    List<CheckpointModel> checkpointsList = [];

    for (var i = 0; i < checkpointsMap.length; i++) {
      CheckpointModel checkpoint =
          await parseCheckpoint(checkpointsMap[i]['id']);
      checkpointsList.add(checkpoint);
    }

    return checkpointsList;
  }

  static Future<List<GoalModel>> goals() async {
    final db = await database();

    final List<Map<String, dynamic>> goalsMap = await db.query('goals');

    List<GoalModel> goalsList = [];

    for (var i = 0; i < goalsMap.length; i++) {
      GoalModel goal = await parseGoal(goalsMap[i]['id']);
      goalsList.add(goal);
    }

    return goalsList;
  }

  static Future<void> insertGoal(GoalModel goal) async {
    final db = await database();
    await db.insert('goals', goal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertCheckpoint(
      CheckpointModel checkpoint, int goalId) async {
    final db = await database();

    await db.insert('checkpoints', checkpoint.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    final goalsList = await goals();
    final goal = goalsList.firstWhere((element) => element.id == goalId);

    var goalCheckpoints = goal.checkpoints.map((e) => e.id).toList();
    bool inList = false;
    for (int j = 0; j < goalCheckpoints.length; j++) {
      if (goalCheckpoints[j] == checkpoint.id) {
        inList = true;
        break;
      }
    }
    if (inList == false) {
      insertGoal(GoalModel(
          id: goalId,
          completed: goal.completed,
          name: goal.name,
          description: goal.description,
          deadline: goal.deadline,
          checkpoints: goal.checkpoints + [checkpoint]));
    }
  }

  static Future addCheckpoint(bool value, String text, int goalId) async {
    final List<CheckpointModel> checkpointsList = await checkpoints();
    final int checkpointId =
        checkpointsList.isEmpty ? 0 : checkpointsList.last.id + 1;
    final CheckpointModel checkpoint =
        CheckpointModel(id: checkpointId, value: value, text: text);
    await insertCheckpoint(checkpoint, goalId);
    return 0;
  }

  static Future addGoal(
    String name,
    String description,
    DateTime deadline,
  ) async {
    final List<GoalModel> goalsList = await goals();
    final int goalId = goalsList.isEmpty ? 0 : goalsList.last.id + 1;
    final GoalModel goal = GoalModel(
        id: goalId,
        completed: false,
        name: name,
        description: description,
        deadline: deadline,
        checkpoints: []);
    await insertGoal(goal);
    return 0;
  }

  static Future<int> removeCheckpoint(int checkpointId) async {
    final db = await database();
    return db.delete(
      'checkpoints',
      where: "id = ?",
      whereArgs: [checkpointId],
    );
  }

  static Future<int> removeGoal(int goalId) async {
    final db = await database();

    List<GoalModel> goalsList = await goals();
    GoalModel goal = goalsList.firstWhere((element) => element.id == goalId);
    List<int> goalCheckpointsIds = goal.checkpoints.map((e) => e.id).toList();

    for (var i = 0; i < goalCheckpointsIds.length; i++) {
      await removeCheckpoint(goalCheckpointsIds[i]);
    }

    return db.delete(
      'goals',
      where: "id = ?",
      whereArgs: [goalId],
    );
  }
}
