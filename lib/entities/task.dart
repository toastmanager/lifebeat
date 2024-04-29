import 'package:lifebeat/entities/checkpoint.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Task{
  @Id()
  int id;
  String text;
  bool status;
  @Property(type: PropertyType.date)
  DateTime date;
  final checkpoints = ToMany<Checkpoint>();

  Task({
    this.id = 0,
    required this.text,
    required this.status,
    required this.date,
  });

  void switchStatus() {
    status = !status;
  }
}