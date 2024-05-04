import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifebeat/app.dart';
import 'package:lifebeat/objectbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifebeat/utils/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

late ObjectBox objectbox;
late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  objectbox = await ObjectBox.create();
  await Settings.init();
  prefs = Settings.prefs;

  runApp(const ProviderScope(child: MainApp()));
}