import 'dart:convert';
import 'package:lifebeat/models/checkpoint_model.dart';

class TaskModel {
  final int id;
  final bool completed;
  late final Duration duration;
  late double progress;
  late final int minutesLeft;
  late final String timeLeft;
  final String name;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  List<CheckpointModel> checkpoints;
  int? parent;

  TaskModel({
    required this.id,
    required this.completed,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.checkpoints,
    this.parent,
  }) {
    duration = getDuration();
    progress = getProgress();
    minutesLeft = endTime.difference(DateTime.now()).inMinutes;
    timeLeft = getTimeLeft();
  }

  double getProgress() {
    int finished = 0;

    if (checkpoints.isEmpty) {
      return 0;
    }

    for (int i = 0; i < checkpoints.length; i++) {
      if (checkpoints[i].value == true) {
        finished++;
      }
    }
    return finished / checkpoints.length * 100;
  }

  Duration getDuration() {
    return endTime.difference(startTime);
  }

  String getTimeLeft() {
    if (startTime.difference(DateTime.now()).inMinutes > 0) {
      return "Ожидание";
    }
    if (minutesLeft > 60 && minutesLeft < 1440) {
      int hours = (minutesLeft / 60).truncate();
      String minutes = (minutesLeft - (hours * 60)).toString();
      return "$hours ч. ${minutes.length == 1 ? "0$minutes" : minutes} м.";
    }
    if (minutesLeft > 1440) {
      return "${endTime.difference(DateTime.now()).inDays} дней";
    }
    if (minutesLeft < 0) {
      if (progress == 100.0) {
        return "Завершено";
      } else {
        return "Просрочено";
      }
    }
    return "${minutesLeft.toString()} минут";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parent': parent,
      'completed': completed ? 1 : 0,
      'progress': progress,
      'name': name,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'checkpoints': jsonEncode(checkpoints.map((e) => e.id).toList()),
    };
  }

  @override
  String toString() {
    return "TaskModel(id: $id, parent: $parent, progress: $progress, name: $name, description: $description, start_time: $startTime, end_time: $endTime, checkpoints: $checkpoints)";
  }
}
