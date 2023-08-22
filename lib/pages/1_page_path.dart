import 'package:flutter/material.dart';

import '../constants.dart';
import '1_path_things.dart/lesson_data.dart';
import '1_path_things.dart/expandable_widget.dart';

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

// Add more SubSections as needed
class SubSection extends StatelessWidget {
  final String title;
  final Color sectionColor;

  final List<ExpandableWidget> expandableWidgets;

  const SubSection({
    required this.title,
    this.sectionColor = mainColor, // Default background color
    required this.expandableWidgets,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100), color: sectionColor),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 24, color: secondaryColor, fontFamily: 'Nunito'),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: expandableWidgets,
            ),
          ),
        ],
      ),
    );
  }
}
