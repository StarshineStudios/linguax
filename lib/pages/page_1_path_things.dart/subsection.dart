import 'package:flutter/material.dart';
import 'expandable_widget.dart';
import '../../constants.dart';
import 'audio_lesson_button.dart';

// Add more SubSections as needed
class SubSection extends StatelessWidget {
  //final String title;
  final Color sectionColor;

  final AudioLessonButton audioLessonButton;
  final List<ExpandableWidget> expandableWidgets;
  //final String imagePath;

  const SubSection({
    //required this.title,
    this.sectionColor = mainColor, // Default background color
    required this.audioLessonButton,
    required this.expandableWidgets,
    //required this.imagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Center(
            child: audioLessonButton,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: expandableWidgets,
          ),
        ],
      ),
    );
  }
}
