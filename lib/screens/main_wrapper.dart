import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifebeat/components/navbar.dart';
import 'package:lifebeat/screens/goals_page.dart';
import 'package:lifebeat/screens/regular_tasks.dart';
import 'package:lifebeat/screens/schedule_page.dart';
import 'package:lifebeat/screens/settings_page.dart';
import '../utils/vars.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  List<Widget> pagesList = const [
    SchedulePage(),
    GoalsPage(),
    RegularTasksPage(),
    Placeholder(),
    SettingsPage(),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Navbar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index)
      ),
      body: pagesList[currentIndex],
    );
  }
}

class LifebeatFloatingActionButton extends StatelessWidget {
  const LifebeatFloatingActionButton({super.key, required this.action});

  final Function() action;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: action,
            backgroundColor: AppColors.purple,
            shape: const OvalBorder(),
            child: const Icon(CupertinoIcons.plus),);
  }
}