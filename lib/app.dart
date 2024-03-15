import 'package:flutter/material.dart';
import 'package:lifebeat/screens/main_wrapper.dart';
import 'package:lifebeat/styles/text_styles.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: "lifebeat",
      title: 'LifeBeat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Manrope',
        colorScheme: const ColorScheme.dark(
          background: Color(0xFF0F141A),
          onBackground: Color(0xFFDADDE5),
          onSurface: Color(0xFFDADDE5),
          onSurfaceVariant: Color(0xFF797C80),
          surface: Color(0xFF1B2026),
          primary: Color(0xFFFF5833),
          onPrimary: Color(0xFFDADDE5),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppTexts.headingSize,
          ),
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppTexts.bodySize,
          ),
          bodyMedium: TextStyle(
            fontSize: AppTexts.bodySize,
          )
        ),
      ),
      home: const MainWrapper(),
    );
  }
}
