import 'package:flutter/material.dart';

import '../constants.dart';
import 'page_1_path_things.dart/lesson_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

//const generalBox = 'darkModeTutorial';

class PagePath extends StatelessWidget {
  const PagePath({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(generalBox).listenable(),
      builder: (context, box, widget) {
        return Scaffold(
          backgroundColor: secondaryColor,
          appBar: AppBar(
            title: const Text(
              'Path',
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
