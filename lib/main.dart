import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifebeat/app.dart';
import 'package:lifebeat/objectbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late ObjectBox objectbox;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  objectbox = await ObjectBox.create();

  runApp(const ProviderScope(child: MainApp()));
}