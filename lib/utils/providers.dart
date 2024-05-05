import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifebeat/utils/settings.dart';

final tasksDay = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final pageIndex = StateProvider<int>((ref) {
  return 0;
});

final languageCode = StateProvider<String>((ref) =>
  Settings.languageCode
);