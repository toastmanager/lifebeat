import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifebeat/screens/goals_screen.dart';
import 'package:lifebeat/screens/settings_page.dart';
import 'package:lifebeat/screens/tasks_page.dart';
import 'package:lifebeat/utils/providers.dart';

final List<Widget> pages = [
  const TasksPage(),
  const GoalListScreen(),
  const SettingsPage(),
];

class MainWrapper extends ConsumerWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: pages[ref.watch(pageIndex)],
      bottomNavigationBar: const NavBar(),
    );
  }
}

class NavBar extends ConsumerWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Theme.of(context).colorScheme.onSurface,
      currentIndex: ref.watch(pageIndex),
      onTap: (value) => ref.read(pageIndex.notifier).state = value,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_rounded),
          label: 'Schedule',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flag_rounded),
          label: 'Goals',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: 'Settings',
        ),
      ],
    );
  }
}