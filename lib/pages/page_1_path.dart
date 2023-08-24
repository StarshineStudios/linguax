import 'package:flutter/material.dart';

import '../constants.dart';
import 'page_1_path_things.dart/lesson_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

//const generalBox = 'darkModeTutorial';

class PagePath extends StatelessWidget {
  final Box<dynamic> box;
  const PagePath({Key? key, required this.box}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var darkMode = box.get('darkMode', defaultValue: false);

    return ValueListenableBuilder(
      valueListenable: Hive.box(generalBox).listenable(),
      builder: (context, box, widget) {
        return Scaffold(
          backgroundColor: darkMode ? darkColor : secondaryColor,
          appBar: AppBar(
            backgroundColor: mainColor,
            title: const Text(
              'Course',
              style: TextStyle(color: secondaryColor),
            ),
          ),
          body: ListView(
            children: subsections(box),
          ),
        );
      },
    );
  }
}
