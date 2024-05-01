import 'package:flutter/material.dart';
import 'package:lifebeat/components/lbtextfield.dart';
import 'package:lifebeat/components/surface.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Surface(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: 12,
                top: 15,
              ),
              child: Column(
                children: [
                  LBTextField(
                    label: Text(''),
                  ),
                  LBTextField(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}