import 'package:flutter/material.dart';
import 'package:lifebeat/components/navbar.dart';

import '../scripts/vars.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key, required this.child, required this.currentPage, this.floatingActionButtonAction});

  final Function()? floatingActionButtonAction;
  final Widget child;
  final String currentPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        bottomNavigationBar: Navbar(currentPage: currentPage),
        backgroundColor: Colors.transparent,
        floatingActionButton: floatingActionButtonAction != null ? LifebeatFloatingActionButton(action: floatingActionButtonAction!) : null,
        body: child,
      ),
    );
  }
}

class LifebeatFloatingActionButton extends StatelessWidget {
  const LifebeatFloatingActionButton({super.key, required this.action});

  final Function() action;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: action,
            backgroundColor: AppColors.purple,
            shape: const OvalBorder(),
            child: Text(
              '+',
              style: AppTexts.headingBold,
            ));
  }
}