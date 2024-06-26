import 'package:lifebeat/entities/task.dart';
import 'package:lifebeat/utils/settings.dart';

final class TaskFuncs {
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

  static String dmDate(DateTime date) {
    // Returns string with DD.MM format
    return "${date.day < 10 ? 0 : ''}${date.day}.${date.month < 10 ? 0 : ''}${date.month}";
  }
  
  static String ymdDate(DateTime date) {
    // Returns string with YYYY.MM.DD format
    return "${date.year}.${date.month < 10 ? 0 : ''}${date.month}.${date.day < 10 ? 0 : ''}${date.day}";
  }

  static bool isDateBeforeTime(int timeInMinutes, DateTime date) {
    if (date.hour * 60 + date.minute < timeInMinutes) {
      return true;
    } else {
      return false;
    }
  }

  static bool isDateAfterTime(int timeInMinutes, DateTime date) {
    if (date.hour * 60 + date.minute > timeInMinutes) {
      return true;
    } else {
      return false;
    }
  }

  static bool isDateAfterTaskDayTime(Task task, DateTime date) {
    if (task.dayTime == DayTime.morning) {
      return isDateAfterTime(Settings.afternoonBeginTime, date);
    }
    if (task.dayTime == DayTime.afternoon) {
      return isDateAfterTime(Settings.eveningBeginTime, date);
    }
    return isDateAfterTime(1439, date);
  }

  static bool isTaskBeforeByDays(DateTime taskDate, DateTime date) {
    if (taskDate.year <= date.year &&
      taskDate.month <= taskDate.month &&
      taskDate.day < date.day
    ) {
      return true;
    }
    return false;
  }

  static bool isTaskEqualByDays(DateTime taskDate, DateTime date) {
    if (taskDate.year == date.year &&
      taskDate.month == taskDate.month &&
      taskDate.day == date.day
    ) {
      return true;
    }
    return false;
  }

  static String timeByMinutes(int minutes) {
    final int hours = minutes ~/ 60;
    final int mins = minutes - (minutes ~/ 60) * 60;
    return "${hours < 10 ? 0 : ''}$hours:${mins < 10 ? 0 : ''}$mins";
  }
}