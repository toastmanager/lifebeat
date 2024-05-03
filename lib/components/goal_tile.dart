import 'package:flutter/material.dart';
import 'package:lifebeat/components/surface.dart';
import 'package:lifebeat/entities/goal.dart';

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
        children: [
          Text(goal.text)
        ],
      ),
    );
  }
}