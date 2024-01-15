import 'dart:convert';
import 'package:lifebeat/models/checkpoint_model.dart';

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
    midDuration = getDuration();
    isWeekDays = weekDays == null ? false : true;
    isIntervallic = interval == null ? false : true;
  }

  void tests() {
    if (weekDays == null && interval == null) {
      throw Exception("No week days or interval. There must to be at least one");
    }
    if (weekDays != null) {
      if (weekDays!.length > 7) {
        throw Exception("More than 7 days in weekDays");
      }
    }
  }

  Duration getDuration() {
    return const Duration(days: 0);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'start_time': startTime,
      'end_time': endTime,
      'week_days': weekDays ?? jsonEncode(weekDays!),
      'interval': interval ?? interval!.inDays,
      'checkpoints': jsonEncode(checkpoints.map((e) => e.id).toList()),
    };
  }
}
