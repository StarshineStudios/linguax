import 'package:flutter/material.dart';
import 'expandable_widget.dart';
import '../../constants.dart';
import 'audio_lesson_button.dart';

// Add more SubSections as needed
class SubSection extends StatelessWidget {
  final String title;
  final Color sectionColor;

  final AudioLessonButton audioLessonButton;
  final List<ExpandableWidget> expandableWidgets;
  final String imagePath;

  const SubSection({
    required this.title,
    this.sectionColor = mainColor, // Default background color
    required this.audioLessonButton,
    required this.expandableWidgets,
    required this.imagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Container(
                decoration: const BoxDecoration(
                    //color: Colors.black,
                    ),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 24,
                        color: secondaryColor,
                        fontFamily: 'Nunito'),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Center(
                child: audioLessonButton,
              ),
              Center(
                child: Column(
                  children: expandableWidgets,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
