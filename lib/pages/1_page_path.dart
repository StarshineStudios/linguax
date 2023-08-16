import 'package:flutter/material.dart';

import '../constants.dart';
import '1_path_things.dart/subsections.dart';

class PagePath extends StatelessWidget {
  const PagePath({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
          title: const Text(
            'Path',
            style: TextStyle(color: secondaryColor),
          ),
        ),
        body: ListView(
          children: subsections,
        ));
  }
}
