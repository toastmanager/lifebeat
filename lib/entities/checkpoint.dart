import 'package:objectbox/objectbox.dart';

@Entity()
class Checkpoint {
  @Id()
  int id;
  String text;
  bool finished;

  Checkpoint({
    this.id = 0,
    this.finished = false,
    required this.text,
  });
}