import 'package:flutter/material.dart';
import '../entities/goal.dart';
import '../main.dart';

class GoalListScreen extends StatefulWidget {
  const GoalListScreen({super.key});

  @override
  State<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends State<GoalListScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Goal>>(
      stream: objectbox.getGoals(),
      builder: (context, snapshot) {
        if (snapshot.data?.isNotEmpty ?? false) {
          List<Goal> goalList = snapshot.data ?? [];
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.hasData ? snapshot.data!.length : 0,
            itemBuilder: (context, index) {
              Goal goal = goalList[index];
              return Column(
                children: [
                  Text(goal.text),
                  Text(goal.description),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      itemCount: goal.checkpoints.length,
                      itemBuilder: (context, index) => Text("${goal.checkpoints[index].text} ${goal.checkpoints[index].finished}"),
                    ),
                  )
                ],
              );
            }
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}