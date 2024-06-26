import 'package:lifebeat/entities/checkpoint.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Goal {
  @Id()
  int id;
  int importance;
  String description;
  String text;
  @Property(type: PropertyType.date)
  DateTime begin;
  @Property(type: PropertyType.date)
  DateTime deadline;
  final checkpoints = ToMany<Checkpoint>();

  Goal({
    this.id = 0,
    this.importance = 2,
    required this.description,
    required this.text,
    required this.begin,
    required this.deadline,
  });
}