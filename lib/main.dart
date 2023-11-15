import 'package:flutter/material.dart';
import 'pages/goals_page.dart';
import 'pages/task_details.dart';

void main() {
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
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const GoalsPage(),
        },
      ),
    );
  }
}
