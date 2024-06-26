import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lifebeat/screens/main_wrapper.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru')
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF5833),
          background: Color(0xFF0F141A),
          outline: Color(0xFF3C3C3C),
          surface: Color(0xFF161E29),
          onSurface: Color(0xFFDADDE5),
          onPrimary: Color(0xFFDADDE5),
        ),
        fontFamily: 'Manrope',
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
          labelMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          )
        ),
      ),
      home: const SafeArea(
        child: MainWrapper()
      ),
    );
  }
}