import 'dart:convert';
import 'package:lifebeat/models/checkpoint_model.dart';
import 'package:lifebeat/models/task_model.dart';

class RegularTaskModel {
  final int id;
  late Duration midDuration;
  final String name;
  final String description;
  final String startTime;
  final String endTime;
  late final bool isWeekDays;
  List<String>? weekDays;
  late final bool isIntervallic;
  Duration? interval;
  List<CheckpointModel> checkpoints;

  RegularTaskModel({
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.weekDays,
    this.interval,
    required this.checkpoints,
  }) {
    tests();
    midDuration = getDuration();
    isWeekDays = weekDays == null ? false : true;
    isIntervallic = interval == null ? false : true;
  }

  bool isCorrectTime(String time) {
    if (int.parse(time[0]) > 2 || int.parse(time[3]) > 5) {
      return false;
    }
    if (int.parse(time[0]) == 2 && int.parse(time[1]) > 4) {
      return false;
    }
    return true;
  }

  void tests() {
    if (weekDays == null && interval == null) {
      throw Exception(
          "No week days or interval. There must to be at least one");
    }
    if (weekDays != null) {
      if (weekDays!.length > 7) {
        throw Exception("More than 7 days in weekDays");
      }
    }
    if (!isCorrectTime(startTime)) {
      throw Exception("Incorrect startTime");
    }
    if (!isCorrectTime(endTime)) {
      throw Exception("Incorrect endTime");
    }
  }

  Duration getDuration() {
    return const Duration(days: 0);
  }

  TaskModel toTaskModel(DateTime day, taskId) {
    return TaskModel(
        id: taskId,
        completed: false,
        name: name,
        description: description,
        startTime: DateTime(
            day.year,
            day.month,
            day.day,
            int.parse(startTime.substring(1, 2)),
            int.parse(startTime.substring(3, 4))),
        endTime: DateTime(
            day.year,
            day.month,
            day.day,
            int.parse(endTime.substring(1, 2)),
            int.parse(endTime.substring(3, 4))),
        checkpoints: checkpoints);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'start_time': startTime,
      'end_time': endTime,
      'week_days': weekDays == null ? null : jsonEncode(weekDays!),
      'interval': interval?.inDays,
      'checkpoints': jsonEncode(checkpoints.map((e) => e.id).toList()),
    };
  }
}
