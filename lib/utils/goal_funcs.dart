import '../entities/goal.dart';

class GoalFuncs {
  static Map<int, List<Goal>> sameDayGoals(List<Goal> goalList) {
    // Return Map with goals at the same day.
    // May contain duplicates in whole map but not in day list
    Map<int, List<Goal>> sameHeight = {};

    for (Goal goal in goalList) {
      if (sameHeight[goal.begin.day] != null) {
        sameHeight[goal.begin.day]!.add(goal);
      } else {
        sameHeight[goal.begin.day] = [goal];
      }
      if (goal.begin.day != goal.deadline.day) {
        for (int l = goal.begin.day + 1; l <= goal.deadline.day; l++) {
          if (sameHeight[l] != null) {
            sameHeight[l]!.add(goal);
          } else {
            sameHeight[l] = [goal];
          }
        }
      }
    }

    return sameHeight;
  }
  
}