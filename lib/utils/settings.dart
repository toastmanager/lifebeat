import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final class Settings {
  static late final SharedPreferences prefs;

  static String afternoonBeginTimeKey = 'afternoonBeginTime';
  static String eveningBeginTimeKey = 'eveningBeginTime';
  static String languageKey = 'languageCode';

  static Future init() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getInt(afternoonBeginTimeKey) == null) {
      prefs.setInt(afternoonBeginTimeKey, defaultAfternoonBeginTime);
    }

    if (prefs.getInt(eveningBeginTimeKey) == null) {
      prefs.setInt(eveningBeginTimeKey, defaultEveningBeginTime);
    }

    if (prefs.getString(languageKey) == null) {
      if (AppLocalizations.supportedLocales.contains(Locale(Platform.localeName.split('_')[0]))) {
        prefs.setString(languageKey, Platform.localeName.split('_')[0]);
      } else {
        prefs.setString(languageKey, 'en');
      }
    }
  }

  static int defaultAfternoonBeginTime = 780;
  static int defaultEveningBeginTime = 1020;
  static int afternoonBeginTime = prefs.getInt(afternoonBeginTimeKey)!;
  static int eveningBeginTime = prefs.getInt(eveningBeginTimeKey)!;
  static String languageCode = prefs.getString(languageKey)!;

  static void updateLanugageCode(String newLanguageCode) {
    prefs.setString(languageKey, newLanguageCode);
    languageCode = newLanguageCode;
  }
}