import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color grayBlueLight = Color(0xffb232d33);
  static const Color grayBlueDark = Color(0xffb12171a);
  static const Color purple = Color(0xffb8b17e5);
  static const Color purpleDark = Color(0xffb5d0f99);
  static const Color white = Color(0xffbdadde5);
  static const Color lightBlue = Color(0xff5A6780);
  static const Color accentBlue = Color(0xff1C2D4D);

  static const LinearGradient backgroundGradient = LinearGradient(
      begin: Alignment(0.00, -9.00),
      end: Alignment.bottomCenter,
      colors: <Color>[
        AppColors.purple,
        AppColors.grayBlueDark,
      ]);
}

abstract final class Routes {
  static const goals = '/goals';
  static const schedule = '/schedule';
  static const settings = '/settings';
  static const regularTasks = '/regular_tasks';
}

abstract final class ItemType {
  static const goal = 'goal';
  static const task = 'task';
  static const regularTask = 'regular_task';
}
