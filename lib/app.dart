import 'package:flutter/material.dart';
import 'package:lifebeat/screens/main_wrapper.dart';
import 'package:lifebeat/styles/text_styles.dart';


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
          colorScheme: const ColorScheme.dark(
            background: Color(0xFF1A1A1A),
            onBackground: Color(0xFFDADDE5),
            onSurface: Color(0xFFDADDE5),
            onSurfaceVariant: Color(0xFF797C80),
            surface: Color(0xFF262626),
            primary: Color(0xFF8D33FF),
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
      ),
    );
  }
}
