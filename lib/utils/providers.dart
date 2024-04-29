import 'package:flutter_riverpod/flutter_riverpod.dart';

final tasksDay = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final pageIndex = StateProvider<int>((ref) {
  return 0;
});