import 'package:flutter/material.dart';
import 'package:lifebeat/pages/main_wrapper.dart';
import 'package:lifebeat/pages/new_task_goal_page.dart';
import 'package:lifebeat/pages/regular_task_details.dart';
import 'package:lifebeat/pages/regular_tasks.dart';
import 'package:lifebeat/pages/settings_page.dart';
import 'package:lifebeat/scripts/settings.dart';
import 'package:lifebeat/scripts/vars.dart';
import 'package:lifebeat/pages/goals_page.dart';
import 'package:lifebeat/pages/schedule_page.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        restorationScopeId: "lifebeat",
        title: 'LifeBeat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          fontFamily: 'Manrope',
          textTheme: const TextTheme(
            // Heading Text
            bodyLarge: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            // Regular Text
            bodyMedium: TextStyle(
              color: AppColors.white,
              fontSize: 16,
            )
          ),
        ),
        initialRoute: Settings.initPage,
        routes: {
          Routes.goals: (context) => const GoalsPage(),
          Routes.schedule: (context) => const SchedulePage(),
          '/new_task': (context) =>
              const MainWrapper(currentPage: '/new_task', child: NewTaskPage()),
          '/new_regular_task': (context) => MainWrapper(
              currentPage: '/new_regular_task', child: NewRegularTaskPage()),
          '/new_goal': (context) =>
              const MainWrapper(currentPage: '/new_goal', child: NewTaskPage()),
          Routes.settings: (context) => const MainWrapper(
              currentPage: Routes.settings, child: SettingsPage()),
          '/regular_task_details': (context) => MainWrapper(
                currentPage: '/regular_task_details',
                child: RegularTaskDetailsPage(
                    taskId: 0, updateItemComponent: () {}, updateItems: () {}),
              ),
          Routes.regularTasks: (context) => const RegularTasksPage(),
        },
      ),
    );
  }
}
