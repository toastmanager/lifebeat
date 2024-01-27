import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lifebeat/pages/main_wrapper.dart';
import 'package:lifebeat/pages/new_task_goal_page.dart';
import 'package:lifebeat/pages/regular_task_details.dart';
import 'package:lifebeat/pages/settings_page.dart';
import 'package:lifebeat/scripts/settings.dart';
import 'package:lifebeat/scripts/vars.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

import 'package:lifebeat/pages/goals_page.dart';
import 'package:lifebeat/pages/schedule_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows | Platform.isLinux | Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
        size: Size(380, 700),
        center: true,
        skipTaskbar: false,
        title: "Lifebeat");
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  await Settings.init();

  if (Platform.isAndroid) {
    if (Settings.dbPath != Settings.defaultDBPath) {
      await Permission.manageExternalStorage.request();
    }
  }

  runApp(const App());
}

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
        ),
        initialRoute: '/regular_task_details',
        routes: {
          Routes.goals: (context) => const GoalsPage(),
          Routes.schedule: (context) => const SchedulePage(),
          '/new_task': (context) =>
              const MainWrapper(currentPage: '/new_task', child: NewTaskPage()),
          '/new_regular_task': (context) => MainWrapper(
              currentPage: '/new_regular_task', child: NewRegularTaskPage()),
          '/new_goal': (context) =>
              const MainWrapper(currentPage: '/new_goal', child: NewTaskPage()),
          '/settings': (context) => const MainWrapper(
              currentPage: '/settings', child: SettingsPage()),
          '/regular_task_details': (context) => MainWrapper(
                currentPage: '/regular_task_details',
                child: RegularTaskDetailsPage(
                    taskId: 0, updateItemComponent: () {}, updateItems: () {}),
              )
        },
      ),
    );
  }
}
