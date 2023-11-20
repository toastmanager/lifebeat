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

  static CheckpointModel parseCheckpoint(
      int i, List<Map<String, dynamic>> checkpointsMap) {
    return CheckpointModel(
      id: checkpointsMap[i]['id'] as int,
      text: checkpointsMap[i]['text'] as String,
      value: checkpointsMap[i]['value'] as int == 1 ? true : false,
    );
  }

  static GoalModel parseGoal(int i, List<Map<String, dynamic>> goalsMap,
      List<Map<String, dynamic>> checkpointsMap) {
    DateTime deadline = DateTime.parse(goalsMap[i]['deadline'] as String);
    List<int> checkpointIds =
        jsonDecode(goalsMap[i]['checkpoints']).cast<int>().toList();
    List<CheckpointModel> checkpoints = [];

    for (int j = 0; j < checkpointIds.length; j++) {
      checkpoints.add(parseCheckpoint(j, checkpointsMap));
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

    return List.generate(checkpointsMap.length, (i) {
      return parseCheckpoint(i, checkpointsMap); // There is error
    });
  }

  static Future<List<GoalModel>> goals() async {
    final db = await database();

    final List<Map<String, dynamic>> goalsMap = await db.query('goals');
    final List<Map<String, dynamic>> checkpointsMap =
        await db.query('checkpoints');

    return List.generate(goalsMap.length, (i) {
      GoalModel goal = parseGoal(i, goalsMap, checkpointsMap);
      return goal;
    });
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

    var checkpointIds = goal.checkpoints.map((e) => e.id).toList();
    bool inList = false;
    for (int j = 0; j < checkpointIds.length; j++) {
      if (checkpointIds[j] == checkpoint.id) {
        inList = true;
        break;
      }
    }
    if (inList == false) {
      insertGoal(GoalModel(id: goalId, completed: goal.completed, name: goal.name, description: goal.description, deadline: goal.deadline, checkpoints: goal.checkpoints + [checkpoint]));
    }
  }
}
