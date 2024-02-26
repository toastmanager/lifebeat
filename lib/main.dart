import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lifebeat/app.dart';
import 'package:lifebeat/utils/settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows | Platform.isLinux | Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
        size: Size(380, 700),
        center: true,
        skipTaskbar: false,
        title: "Lifebeat");
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  await Settings.init();

  if (Platform.isAndroid) {
    if (Settings.dbPath != Settings.defaultDBPath) {
      await Permission.manageExternalStorage.request();
    }
  }

  runApp(const App());
}