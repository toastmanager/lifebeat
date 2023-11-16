import 'dart:convert';

class GoalModel {
  final int id;
  final bool completed;
  late final int duration;
  late final double progress;
  late final int daysLeft;
  final String name;
  final String description;
  final DateTime deadline;
  final List<CheckpointModel> checkpoints;

  GoalModel({
    required this.id,
    required this.completed,
    required this.name,
    required this.description,
    required this.deadline,
    required this.checkpoints,
  }) { 
    duration = getDateDurations();
    progress = getProgress();
    daysLeft = deadline.difference(DateTime.now()).inDays;
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

  int getDateDurations() {
    return deadline.difference(DateTime.now()).inDays;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'completed': completed ? 1 : 0,
      'duration': duration,
      'progress': progress,
      'daysLeft': daysLeft,
      'name': name,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'checkpoints': jsonEncode(checkpoints),
    };
  }
}

class CheckpointModel {
  final int id;
  final bool value;
  final String text;

  CheckpointModel({
    required this.id,
    required this.value,
    required this.text,
  });
}
