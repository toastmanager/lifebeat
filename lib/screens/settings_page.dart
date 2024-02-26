import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lifebeat/utils/settings.dart';
import 'package:lifebeat/utils/text_values.dart';
import 'package:lifebeat/styles/text_field_style.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String dbPath = Settings.dbPath;

  @override
  Widget build(BuildContext context) {
    var dbPathController = TextEditingController(text: dbPath);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            onTap: () async {
              if (Platform.isAndroid) {
                var permission = Permission.manageExternalStorage;
                if (await permission.status != PermissionStatus.granted) {
                  await permission.request();
                }
              }
              String? newDBPath = await FilePicker.platform.getDirectoryPath();
              dbPath =
                  newDBPath == null ? dbPath : join(newDBPath, 'database.db');
              await Settings.setDBPath(dbPath);
              await Settings.reload();
              setState(() {});
            },
            decoration: textFieldDecoration(TextValue.wayToDataBaseText),
            readOnly: true,
            controller: dbPathController,
          )),
        ],
      ),
    );
  }
}
