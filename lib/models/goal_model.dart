import 'package:flutter/material.dart';

class GoalModel {
  final int id;
  final bool completed;
  late final int duration;
  late final double progress;
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
    progress = 50;
  }

  int getDateDurations() {
    return deadline.difference(DateTime.now()).inDays;
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
