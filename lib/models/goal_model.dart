class GoalModel {
  final int id;
  final bool completed;
  late final int duration;
  late final double progress;
  final String name;
  final String description;
  final DateTime deadline;

  GoalModel({
    required this.id,
    required this.completed,
    required this.name,
    required this.description,
    required this.deadline,
  }) { 
    duration = getDateDurations();
    progress = 50;
  }

  int getDateDurations() {
    return deadline.difference(DateTime.now()).inDays;
  }
}
