import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../components/lbtextfield.dart';
import '../components/surface.dart';
import '../main.dart';
import '../utils/task_funcs.dart';
import '../entities/goal.dart';
import '../utils/date_funcs.dart';

class GoalPropertiesPage extends StatefulWidget {
  // Update Goal if goal property provided
  // Create new Goal if goal property not provided
  const GoalPropertiesPage({
    super.key,
    this.goal,
    this.initDate,
  });

  final Goal? goal;
  final DateTime? initDate;

  @override
  State<GoalPropertiesPage> createState() => _GoalPropertiesPageState();
}

class _GoalPropertiesPageState extends State<GoalPropertiesPage> {
  late Goal? goal = widget.goal;
  late DateTime beginDate = goal?.begin ?? widget.initDate ?? DateTime.now();
  late DateTime endDate = goal?.deadline ?? widget.initDate ?? DateTime.now();
  late int importance = goal?.importance ?? 2;

  late final nameController = TextEditingController(text: goal?.text);
  late final descController = TextEditingController(text: goal?.description);
  late final beginController = TextEditingController(text: TaskFuncs.ymdDate(beginDate));
  late final endController = TextEditingController(text: TaskFuncs.ymdDate(endDate));


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
            left: 20,
            right: 20,
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.discard),
                )
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (goal != null) {
                      goal!.text = nameController.text;
                      goal!.description = descController.text;
                      goal!.begin = beginDate;
                      goal!.deadline = endDate;
                      goal!.importance = importance;
                      objectbox.updateGoal(goal!);
                    } else {
                      objectbox.addGoal(
                        nameController.text, 
                        descController.text, 
                        beginDate, 
                        endDate,
                        importance,
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.confirm),
                )
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Surface(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 16,
                    bottom: 16,
                  ),
                  child: Column(
                    children: [
                      LBTextField(
                        controller: nameController,
                        label: Text(AppLocalizations.of(context)!.name),
                      ),
                      const SizedBox(height: 15),
                      LBTextField(
                        keyboardType: TextInputType.multiline,
                        controller: descController,
                        label: Text(AppLocalizations.of(context)!.description),
                      ),
                      const SizedBox(height: 15),
                      LBTextField(
                        controller: beginController,
                        label: Text(AppLocalizations.of(context)!.begin_date),
                        readOnly: true,
                        onTap: () async {
                          DateTime newDate = await chooseDate(beginDate, context);
                          if (isSameDate(beginDate, endDate)) {
                            endDate = newDate;
                            endController.text = TaskFuncs.ymdDate(endDate);
                          }
                          beginDate = newDate;
                          beginController.text = TaskFuncs.ymdDate(beginDate);
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 15),
                      LBTextField(
                        controller: endController,
                        label: Text(AppLocalizations.of(context)!.end_date),
                        readOnly: true,
                        onTap: () async {
                          endDate = await chooseDate(endDate, context);
                          endController.text = TaskFuncs.ymdDate(endDate);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Surface(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.importance
                      ),
                      DropdownButton(
                        value: importance,
                        items: [
                          DropdownMenuItem(value: 1, child: Text(AppLocalizations.of(context)!.low_importance)),
                          DropdownMenuItem(value: 2, child: Text(AppLocalizations.of(context)!.average_importance)),
                          DropdownMenuItem(value: 3, child: Text(AppLocalizations.of(context)!.high_importance)),
                        ],
                        onChanged: (value) => setState(() =>
                          importance = value ?? importance
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 60)
              ],
            ),
          ),
        ),
      ),
    );
  }
}