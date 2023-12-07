import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color grayBlueLight = Color(0xffb232d33);
  static const Color grayBlueDark = Color(0xffb12171a);
  static const Color purple = Color(0xffb8b17e5);
  static const Color purpleDark = Color(0xffb5d0f99);
  static const Color white = Color(0xffbdadde5);

  static const LinearGradient backgroundGradient = LinearGradient(
      begin: Alignment(0.00, -9.00),
      end: Alignment.bottomCenter,
      colors: <Color>[
        AppColors.purple,
        AppColors.grayBlueDark,
      ]);
}

class AppTexts {
  static const appFontStyle = GoogleFonts.openSans;
  static const double bodyFontSize = 14;
  static const double headingFontSize = 24;
  static const Color textColor = AppColors.white;

  static final body = appFontStyle(
      textStyle: const TextStyle(
    fontSize: bodyFontSize,
    color: textColor,
  ));

  static final bodyBold = appFontStyle(
      textStyle: const TextStyle(
    fontSize: bodyFontSize,
    fontWeight: FontWeight.bold,
    color: textColor,
  ));

  static final headingBold = appFontStyle(
      textStyle: const TextStyle(
    fontSize: headingFontSize,
    fontWeight: FontWeight.bold,
    color: textColor,
  ));
}

class Routes {
  static const goals = '/goals';
  static const schedule = '/schedule';
}

class AppInfo {
  static const version = '0.2.4';
}