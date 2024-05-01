import 'package:flutter/material.dart';
import 'package:lifebeat/components/lbtextfield.dart';
import 'package:lifebeat/components/surface.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});


  @override
  Widget build(BuildContext context) {
    final afternoonBeginTime = TextEditingController(
      text: '13:00'
    );
    final eveningBeginTime = TextEditingController(
      text: '17:00'
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Surface(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Начало дня',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Flexible(
                        child: TextField(
                          controller: afternoonBeginTime,
                          textAlign: TextAlign.end,
                          decoration: const InputDecoration(
                            border: InputBorder.none
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Начало вечера',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Flexible(
                        child: TextField(
                          controller: eveningBeginTime,
                          textAlign: TextAlign.end,
                          decoration: const InputDecoration(
                            border: InputBorder.none
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}