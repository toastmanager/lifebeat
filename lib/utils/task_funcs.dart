import 'package:lifebeat/entities/task.dart';

class TaskFuncs {
  static List<List<Task>> groupedTasks(List<Task> tasks) {
    List<Task> morning = [];
    List<Task> afternoon = [];
    List<Task> evening = [];
    for (Task task in tasks) {
      if (task.dayTime == DayTime.morning) {
        morning.add(task);
      }
      if (task.dayTime == DayTime.afternoon) {
        afternoon.add(task);
      }
      if (task.dayTime == DayTime.evening) {
        evening.add(task);
      }
    }
    return [morning, afternoon, evening];
  }
}