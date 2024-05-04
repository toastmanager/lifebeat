import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifebeat/components/goal_tile.dart';
import 'package:lifebeat/screens/goal_properties_page.dart';
import 'package:lifebeat/utils/goal_funcs.dart';
import '../entities/goal.dart';
import '../main.dart';

class GoalListScreen extends StatefulWidget {
  const GoalListScreen({super.key});

  @override
  State<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends State<GoalListScreen> {
  final double cellWidth = 200;
  final double goalHeight = 70;
  late final List<int> days = [for (int i = 1; i <= 30; i++) i];
  late final scrollController = ScrollController(
    initialScrollOffset: (DateTime.now().day - 1) * cellWidth - (cellWidth~/2)
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Goal>>(
      stream: objectbox.getGoals(),
      builder: (context, snapshot) {
        if (snapshot.data?.isNotEmpty ?? false) {
          List<Goal> goalList = snapshot.data ?? [];
          Map<int, List<Goal>> sameHeight = GoalFuncs.sameDayGoals(goalList);
          List<int> addedIdList = [];

          List<Widget> widgets = [
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
          ];

          // print(sameHeight);
          sameHeight.forEach(
            (key, value) {
              print("$key : $value");
              int extraHeight = 0;
              for (int i = 0; i <  value.length; i++) {
                print(value[i].id);
                if (!(addedIdList.contains(value[i].id))) {
                  widgets.add(
                    Positioned(
                      key: Key("goal-${value[i].id}"),
                      top: (54 + (goalHeight + 10) * (i + extraHeight)).toDouble(),
                      left: value[i].begin.day.toDouble() * cellWidth - cellWidth,
                      child: GoalTile(
                        goal: value[i],
                        height: goalHeight,
                        width: ((value[i].deadline.day - value[i].begin.day + 1) * cellWidth),
                      ),
                    )
                  );
                  addedIdList.add(value[i].id);
                } else {
                  extraHeight++;
                }
              }
            }
          );
          print("----------------");

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const GoalPropertiesPage())
              ),
              elevation: 0,
              shape: const CircleBorder(),
              child: const Icon(CupertinoIcons.add),
            ),
            body: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: Stack(
                children: widgets,
              ),
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