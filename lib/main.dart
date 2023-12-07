import 'package:flutter/material.dart';
import 'pages/goals_page.dart';
import 'pages/schedule_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;

void main() {
  if (Platform.isWindows | Platform.isLinux | Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: 'Lifebeat',
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
