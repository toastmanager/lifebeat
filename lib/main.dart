import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lifebeat/pages/main_wrapper.dart';
import 'package:lifebeat/pages/new_task_goal_page.dart';
import 'package:lifebeat/scripts/settings.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

import 'package:lifebeat/pages/goals_page.dart';
import 'package:lifebeat/pages/schedule_page.dart';

void main() async {
  if (Platform.isWindows | Platform.isLinux | Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    WidgetsFlutterBinding.ensureInitialized();
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
        initialRoute: Settings.initPage,
        routes: {
          '/goals': (context) => const GoalsPage(),
          '/schedule': (context) => const SchedulePage(),
          '/new_task': (context) =>
              MainWrapper(currentPage: 'new_task', child: NewTaskPage()),
          '/new_goal': (context) =>
              MainWrapper(currentPage: 'new_goal', child: NewTaskPage()),
        },
      ),
    );
  }
}
