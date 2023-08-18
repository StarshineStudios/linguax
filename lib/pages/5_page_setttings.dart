import 'package:flutter/material.dart';
import '../main.dart';

import 'package:hive_flutter/hive_flutter.dart';

class PageSettings extends StatelessWidget {
  final Box<dynamic> box;
  PageSettings({required this.box});

  Widget build(BuildContext context) {
    var darkMode = box.get('darkMode', defaultValue: false);

    return Container(
      color: Color.fromARGB(0, 0, 0, 0),
      child: Switch(
        value: darkMode,
        onChanged: (val) {
          box.put('darkMode', !darkMode);
        },
      ),
    );
  }
}
