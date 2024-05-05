import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:lifebeat/components/surface.dart';
import 'package:lifebeat/entities/goal.dart';
import 'package:lifebeat/screens/goal_properties_page.dart';
import '../main.dart';

class GoalTile extends StatefulWidget {
  const GoalTile({
    super.key,
    this.width = 200,
    this.height,
    this.onTap,
    required this.goal,
  });

  final double? height;
  final double width;
  final Goal goal;
  final void Function()? onTap;

  @override
  State<GoalTile> createState() => _GoalTileState();
}

class _GoalTileState extends State<GoalTile> {
  late final goal = widget.goal;
  Color? color;

  @override
  Widget build(BuildContext context) {
    double width = widget.width;
    double? height = widget.height;


    if (goal.importance == 1) {
      color = const Color(0xFF272918);
    }
    if (goal.importance == 3) {
      color = const Color(0xFF241829);
    }
    
    return InkWell(
      onTap: widget.onTap,
      child: Surface(
        height: height,
        width: width,
        color: color,
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
        PopupMenuItem(
          child: Text(AppLocalizations.of(context)!.edit),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GoalPropertiesPage(goal: goal),
            )
          ),
        ),
        PopupMenuItem(
          child: Text(AppLocalizations.of(context)!.delete), 
          onTap: () => objectbox.deleteGoal(goal.id),
        ),
      ],
    );
  }
}