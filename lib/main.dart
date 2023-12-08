import 'dart:io';
import 'package:flutter/material.dart';

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
        initialRoute: '/goals',
        routes: {
          '/goals': (context) => const GoalsPage(),
          '/schedule': (context) => const SchedulePage(),
        },
      ),
    );
  }
}
