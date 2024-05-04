import 'package:lifebeat/entities/checkpoint.dart';
import 'package:lifebeat/entities/goal.dart';
import 'package:objectbox/objectbox.dart';

class DayTime {
  static const String morning = 'morning';
  static const String afternoon = 'afternoon';
  static const String evening = 'evening';
}

@Entity()
class Task {
  @Id()
  int id;
  String text;
  bool status;
  @Property(type: PropertyType.date)
  DateTime date;
  String dayTime;
  final parentGoal = ToOne<Goal>();
  final checkpoints = ToMany<Checkpoint>();

  Task({
    this.id = 0,
    required this.text,
    required this.status,
    required this.date,
    required this.dayTime,
  });

  void switchStatus() {
    status = !status;
  }
}