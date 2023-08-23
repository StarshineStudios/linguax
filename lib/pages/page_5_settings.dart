import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

class PageSettings extends StatelessWidget {
  final Box<dynamic> box;
  const PageSettings({super.key, required this.box});

  @override
  Widget build(BuildContext context) {
    var darkMode = box.get('darkMode', defaultValue: false);

    return Container(
      color: const Color.fromARGB(0, 0, 0, 0),
      child: Switch(
        value: darkMode,
        onChanged: (val) {
          box.put('darkMode', !darkMode);
        },
      ),
    );
  }
}
