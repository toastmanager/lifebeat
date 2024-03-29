import 'dart:convert';

import 'package:lifebeat/scripts/settings.dart';
import 'package:lifebeat/scripts/vars.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lifebeat/models/goal_model.dart';
import 'package:lifebeat/models/checkpoint_model.dart';
import 'package:lifebeat/models/task_model.dart';

class DBHelper {
  static Future createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE goals(id INTEGER PRIMARY KEY, completed BOOL, progress FLOAT, daysLeft INT, name TEXT, description TEXT, deadline TEXT, checkpoints TEXT)');
    await db.execute(
        'CREATE TABLE checkpoints(id INTEGER PRIMARY KEY, value BOOL, text TEXT)');
    await db.execute(
        'CREATE TABLE tasks(id INTEGER PRIMARY KEY, completed BOOL, progress FLOAT, name TEXT, description TEXT, start_time TEXT, end_time TEXT, checkpoints TEXT)');
  }

  static Future<Database> database() async {
    return openDatabase(
      Settings.dbPath,
      version: 1,
      onCreate: (db, version) => createDB(db, version),
    );
  }

  static Future<CheckpointModel> parseCheckpoint(int id) async {
    final db = await database();
    final Map<String, dynamic> checkpoint =
        (await db.query('checkpoints', where: "id = ?", whereArgs: [id]))[0];

    return CheckpointModel(
      id: checkpoint['id'] as int,
      text: checkpoint['text'] as String,
      value: checkpoint['value'] as int == 1 ? true : false,
    );
  }

  static Future<List<CheckpointModel>> parseCheckpoints(
      List<int> itemCheckpoints) async {
    List<CheckpointModel> checkpoints = [];

    for (int j = 0; j < itemCheckpoints.length; j++) {
      int checkpointId = itemCheckpoints[j];
      checkpoints.add(await parseCheckpoint(checkpointId));
    }

    return checkpoints;
  }

  static Future<List<CheckpointModel>> parseItemCheckpoints(itemMap) async {
    List<int> itemCheckpoints =
        jsonDecode(itemMap['checkpoints']).cast<int>().toList();
    return await parseCheckpoints(itemCheckpoints);
  }

  static Future<GoalModel> parseGoal(int id) async {
    final db = await database();
    final Map<String, dynamic> goalMap =
        (await db.query('goals', where: "id = ?", whereArgs: [id]))[0];

    DateTime deadline = DateTime.parse(goalMap['deadline'] as String);
    List<CheckpointModel> checkpoints = await parseItemCheckpoints(goalMap);

    return GoalModel(
      id: goalMap['id'] as int,
      completed: goalMap['completed'] as int == 1 ? true : false,
      name: goalMap['name'] as String,
      description: goalMap['description'] as String,
      deadline: deadline,
      checkpoints: checkpoints,
    );
  }

  static Future<TaskModel> parseTask(int id) async {
    final db = await database();
    final Map<String, dynamic> taskMap =
        (await db.query('tasks', where: "id = ?", whereArgs: [id]))[0];

    DateTime startTime = DateTime.parse(taskMap['start_time'] as String);
    DateTime endTime = DateTime.parse(taskMap['end_time'] as String);
    List<CheckpointModel> checkpoints = await parseItemCheckpoints(taskMap);

    return TaskModel(
      id: taskMap['id'] as int,
      completed: taskMap['completed'] as int == 1 ? true : false,
      name: taskMap['name'] as String,
      description: taskMap['description'] as String,
      startTime: startTime,
      endTime: endTime,
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

  static Future<GoalModel> getGoalById(int goalId) async {
    return parseGoal(goalId);
  }

  static Future<TaskModel> getTaskById(int taskId) async {
    return await parseTask(taskId);
  }

  static Future<List<TaskModel>> tasks() async {
    final db = await database();

    final List<Map<String, dynamic>> tasksMap = await db.query('tasks');

    List<TaskModel> tasksList = [];

    for (var i = 0; i < tasksMap.length; i++) {
      TaskModel task = await parseTask(tasksMap[i]['id']);
      tasksList.add(task);
    }

    return tasksList;
  }

  static Future<void> insertGoal(GoalModel goal) async {
    final db = await database();
    await db.insert('goals', goal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertTask(TaskModel task) async {
    final db = await database();
    await db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertCheckpoint(
      CheckpointModel checkpoint, int itemId, String type) async {
    final db = await database();
    bool isGoal = type == ItemType.goal;

    await db.insert('checkpoints', checkpoint.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    late final dynamic item;
    if (isGoal) {
      item = await getGoalById(itemId);
    } else {
      item = await getTaskById(itemId);
    }

    var itemCheckpoints = item.checkpoints.map((e) => e.id).toList();
    bool inList = false;
    for (int j = 0; j < itemCheckpoints.length; j++) {
      if (itemCheckpoints[j] == checkpoint.id) {
        inList = true;
        break;
      }
    }

    if (inList == false) {
      if (isGoal) {
        insertGoal(GoalModel(
            id: itemId,
            completed: item.completed,
            name: item.name,
            description: item.description,
            deadline: item.deadline,
            checkpoints: item.checkpoints + [checkpoint]));
      } else {
        insertTask(TaskModel(
            id: itemId,
            completed: item.completed,
            name: item.name,
            description: item.description,
            startTime: item.startTime,
            endTime: item.endTime,
            checkpoints: item.checkpoints + [checkpoint]));
      }
    }
  }

  static Future addCheckpoint(
      bool value, String text, int goalId, String type) async {
    final List<CheckpointModel> checkpointsList = await checkpoints();
    final int checkpointId =
        checkpointsList.isEmpty ? 0 : checkpointsList.last.id + 1;
    final CheckpointModel checkpoint =
        CheckpointModel(id: checkpointId, value: value, text: text);
    await insertCheckpoint(checkpoint, goalId, type);
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

  static Future addTask(
    String name,
    String description,
    DateTime startTime,
    DateTime endTime,
  ) async {
    final List<TaskModel> tasksList = await tasks();
    final int taskId = tasksList.isEmpty ? 0 : tasksList.last.id + 1;
    final TaskModel task = TaskModel(
        id: taskId,
        completed: false,
        name: name,
        description: description,
        startTime: startTime,
        endTime: endTime,
        checkpoints: []);
    await insertTask(task);
    return 0;
  }

  static Future<int> removeCheckpoint(
      int checkpointId, int itemId, String type) async {
    final db = await database();

    if (type == ItemType.goal) {
      GoalModel goal = await getGoalById(itemId);
      goal.checkpoints.removeWhere((element) => element.id == checkpointId);
      insertGoal(goal);
    }
    if (type == ItemType.task) {
      TaskModel task = await getTaskById(itemId);
      task.checkpoints.removeWhere((element) => element.id == checkpointId);
      insertTask(task);
    }

    return db.delete(
      'checkpoints',
      where: "id = ?",
      whereArgs: [checkpointId],
    );
  }

  static Future<int> removeGoal(int goalId) async {
    final db = await database();

    GoalModel goal = await getGoalById(goalId);
    List<int> goalCheckpointsIds = goal.checkpoints.map((e) => e.id).toList();

    for (var i = 0; i < goalCheckpointsIds.length; i++) {
      await removeCheckpoint(goalCheckpointsIds[i], goalId, ItemType.goal);
    }

    return db.delete(
      'goals',
      where: "id = ?",
      whereArgs: [goalId],
    );
  }

  static Future<int> removeTask(int taskId) async {
    final db = await database();

    TaskModel task = await getTaskById(taskId);
    List<int> taskCheckpointsIds = task.checkpoints.map((e) => e.id).toList();

    for (var i = 0; i < taskCheckpointsIds.length; i++) {
      await removeCheckpoint(taskCheckpointsIds[i], taskId, ItemType.task);
    }

    return db.delete(
      'tasks',
      where: "id = ?",
      whereArgs: [taskId],
    );
  }

  static Future<List<TaskModel>> certainDayTasks(DateTime day) async {
    List<TaskModel> tasksList = await tasks();
    List<TaskModel> todayTasksList = tasksList.where((task) {
      DateTime startTime = task.startTime;
      return startTime.year == day.year &&
          startTime.month == day.month &&
          startTime.day == day.day;
    }).toList();
    return todayTasksList;
  }
}
