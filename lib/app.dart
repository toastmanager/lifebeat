import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifebeat/l10n/l10n.dart';
import 'package:lifebeat/screens/main_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lifebeat/utils/providers.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate, 
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      locale: Locale(ref.watch(languageCode)),
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