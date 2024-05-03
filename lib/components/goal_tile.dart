import 'package:flutter/material.dart';
import 'package:lifebeat/components/surface.dart';
import 'package:lifebeat/entities/goal.dart';

import '../main.dart';

class GoalTile extends StatefulWidget {
  const GoalTile({
    super.key,
    this.width = 200,
    this.height,
    required this.goal,
  });

  final double? height;
  final double width;
  final Goal goal;

  @override
  State<GoalTile> createState() => _GoalTileState();
}

class _GoalTileState extends State<GoalTile> {
  late final width = widget.width;
  late final heigth = widget.height;
  late final goal = widget.goal;

  @override
  Widget build(BuildContext context) {
    return Surface(
      height: heigth,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(goal.text)
          ),
          GoalPopup(
            goal: goal,
          ),
        ],
      ),
    );
  }
}

class GoalPopup extends StatelessWidget {
  const GoalPopup({
    super.key,
    required this.goal,
  });

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem(
          child: Text('Изменить')
        ),
        PopupMenuItem(
          onTap: () => objectbox.deleteGoal(goal.id),
          child: const Text('Удалить')
        ),
      ],
    );
  }
}