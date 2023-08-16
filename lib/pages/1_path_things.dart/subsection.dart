import 'package:flutter/material.dart';
import 'expandable_widget.dart';
import '../../constants.dart';

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
