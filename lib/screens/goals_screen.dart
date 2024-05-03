import 'package:flutter/material.dart';
import 'package:lifebeat/components/goal_tile.dart';
import '../entities/goal.dart';
import '../main.dart';

class GoalListScreen extends StatefulWidget {
  const GoalListScreen({super.key});

  @override
  State<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends State<GoalListScreen> {
  final double cellWidth = 200;
  // late final List<Widget> days = [for (int i = 1; i <= 30; i++) GoalTable(day: i, width: cellWidth)];
  late final List<int> days = [for (int i = 1; i <= 30; i++) i];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Goal>>(
      stream: objectbox.getGoals(),
      builder: (context, snapshot) {
        if (snapshot.data?.isNotEmpty ?? false) {
          List<Goal> goalList = snapshot.data ?? [];
          Map<int, List<Goal>> sameHeight = {};
          List<int> addedIdList = [];

          for (Goal goal in goalList) {
            if (!(addedIdList.contains(goal.id))) {
              if (sameHeight[goal.begin.day] != null) {
                sameHeight[goal.begin.day]!.add(goal);
              } else {
                sameHeight[goal.begin.day] = [goal];
              }
              addedIdList.add(goal.id);
            }
            if (!(addedIdList.contains(goal.id))) {
              if (sameHeight[goal.deadline.day] != null) {
                sameHeight[goal.deadline.day]!.add(goal);
              } else {
                sameHeight[goal.deadline.day] = [goal];
              }
            }
          }

          print(goalList.length);
          print(sameHeight);
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Stack(
              children: <Widget>[
                Column(
                  children: [
                    Row(
                      children: days.map((e) => GoalTable(day: e, width: 200, height: 54)).toList(),
                    ),
                    Expanded(
                      child: Row(
                        children: days.map((e) => const GoalTable(width: 200)).toList(),
                      ),
                    ),
                  ],
                ),
              ] + goalList.map((e) {
              return Positioned(
                top: 54,
                left: e.begin.day.toDouble() * cellWidth - cellWidth,
                child: GoalTile(goal: e, height: 52),
              );
              }).toList(),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class GoalTable extends StatelessWidget {
  const GoalTable({
    super.key,
    this.day,
    this.height,
    required this.width,
  });

  final int? day;
  final double? height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        )
      ),
      height: height,
      child: Center(
        child: Text("${day ?? ''}"),
      ),
    );
  }
}