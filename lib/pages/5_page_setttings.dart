import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../main.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({super.key});

  @override
  _PageSettingsState createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  final GetStorage _data =
      StorageService().box; // Access the singleton instance

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Read the settings from storage

              setState(() {
                Map<String, dynamic>? settings = _data.read('settings');

                // If settings are not null, toggle the 'dark mode' setting
                if (settings != null) {
                  _data
                      .write('settings', {'dark mode': !settings['dark mode']});
                }
              });
            },
            child: const Text('Toggle Dark Mode Setting'),
          ),
        ],
      ),
    );
  }
}
