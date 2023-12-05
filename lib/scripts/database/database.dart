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

    final Map<String, dynamic> checkpoint = checkpointsMap.firstWhere((element) => element['id'] == id);

    return CheckpointModel(
      id: checkpoint['id'] as int,
      text: checkpoint['text'] as String,
      value: checkpoint['value'] as int == 1 ? true : false,
    );
  }

  static Future<GoalModel> parseGoal(
      int i, List<Map<String, dynamic>> goalsMap) async {
    DateTime deadline = DateTime.parse(goalsMap[i]['deadline'] as String);
    List<int> goalsCheckpoints =
        jsonDecode(goalsMap[i]['checkpoints']).cast<int>().toList();
    List<CheckpointModel> checkpoints = [];

    for (int j = 0; j < goalsCheckpoints.length; j++) {
      int checkpointId = goalsCheckpoints[j];
      checkpoints.add(await parseCheckpoint(checkpointId));
    }

    return GoalModel(
      id: goalsMap[i]['id'] as int,
      completed: goalsMap[i]['completed'] as int == 1 ? true : false,
      name: goalsMap[i]['name'] as String,
      description: goalsMap[i]['description'] as String,
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
      CheckpointModel checkpoint = await parseCheckpoint(i);
      checkpointsList.add(checkpoint);
    }

    return checkpointsList;
  }

  static Future<List<GoalModel>> goals() async {
    final db = await database();

    final List<Map<String, dynamic>> goalsMap = await db.query('goals');

    List<GoalModel> goalsList = [];

    for (var i = 0; i < goalsMap.length; i++) {
      GoalModel goal = await parseGoal(i, goalsMap);
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
    final goal = goalsList[goalId];

    var goalsCheckpoints = goal.checkpoints.map((e) => e.id).toList();
    bool inList = false;
    for (int j = 0; j < goalsCheckpoints.length; j++) {
      if (goalsCheckpoints[j] == checkpoint.id) {
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

  static Future<int> deleteCheckpoint(int checkpointId) async {
    final db = await database();
    return db.delete(
      'checkpoints',
      where: "id = ?",
      whereArgs: [checkpointId],
    );
  }

  static Future<int> deleteGoal(int goalId) async {
    final db = await database();

    List<GoalModel> goalsList = await goals();
    GoalModel goal = goalsList.firstWhere((element) => element.id == goalId);
    List<int> goalCheckpointsIds = goal.checkpoints.map((e) => e.id).toList();

    for (var i = 0; i < goalCheckpointsIds.length; i++) {
      await deleteCheckpoint(goalCheckpointsIds[i]);
    }

    return db.delete(
      'goals',
      where: "id = ?",
      whereArgs: [goalId],
    );
  }
}
