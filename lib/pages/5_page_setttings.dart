import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({Key? key}) : super(key: key);

  @override
  _PageSettingsState createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  final GetStorage _data = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                bool? darkMode = _data.read('dark mode');
                if (darkMode != null) {
                  _data.write('dark mode', !darkMode);
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
