import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifebeat/components/surface.dart';
import 'package:lifebeat/utils/providers.dart';
import 'package:lifebeat/utils/settings.dart';
import 'package:lifebeat/utils/task_funcs.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final afternoonBeginTime = TextEditingController(
      text: TaskFuncs.timeByMinutes(Settings.afternoonBeginTime)
    );
    final eveningBeginTime = TextEditingController(
      text: TaskFuncs.timeByMinutes(Settings.eveningBeginTime)
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
                        AppLocalizations.of(context)!.afternoon_begin,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const Spacer(),
                      Flexible(
                        child: TextField(
                          controller: afternoonBeginTime,
                          textAlign: TextAlign.end,
                          decoration: const InputDecoration(
                            border: InputBorder.none
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.evening_begin,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const Spacer(),
                      Flexible(
                        child: TextField(
                          controller: eveningBeginTime,
                          textAlign: TextAlign.end,
                          decoration: const InputDecoration(
                            border: InputBorder.none
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.db_directory,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const TextField()
                ],
              ),
            ),
            const SizedBox(height: 20),
            Surface(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.language,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  DropdownButton(
                    items: const [
                      DropdownMenuItem(
                        value: 'ru',
                        child: Text('Русский')
                      ),
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English')
                      ),
                    ],
                    value: ref.watch(languageCode),
                    onChanged: (value) {
                      String newLanguageCode = value ?? Settings.languageCode;
                      Settings.updateLanugageCode(newLanguageCode);
                      ref.read(languageCode.notifier).state = newLanguageCode;
                    },
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