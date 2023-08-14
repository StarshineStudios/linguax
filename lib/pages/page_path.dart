import 'package:flutter/material.dart';

import '../constants.dart';

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _subsections,
        ),
      ),
    );
  }
}

// Add more SubSections as needed
final List<SubSection> _subsections = [
  const SubSection(
    title: 'Subsection 1',
    sectionColor: Colors.teal,
  ),
  const SubSection(
    title: 'Subsection 2',
    sectionColor: Colors.orange,
  ),
  const SubSection(
    title: 'Subsection 3',
    sectionColor: Colors.lime,
  ),
  const SubSection(
    title: 'Subsection 4',
    sectionColor: Colors.pink,
  ),
  const SubSection(
    title: 'Subsection 5',
    sectionColor: Colors.orange,
  ),
  const SubSection(
    title: 'Subsection 6',
    sectionColor: Colors.purple,
  ),
  const SubSection(title: 'Subsection 7'),
  const SubSection(title: 'Subsection 8'),
  const SubSection(title: 'Subsection 9'),
];

class SubSection extends StatelessWidget {
  final String title;
  final Color sectionColor;
  final List<String> buttons;

  const SubSection({
    required this.title,
    this.sectionColor = mainColor, // Default background color
    this.buttons = const [], // Default empty list of buttons
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
                style: const TextStyle(fontSize: 24, color: secondaryColor),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SubSectionButton(
                  label: 'Vocabulary',
                  buttonColor: sectionColor,
                ),
                SubSectionButton(
                  label: 'Grammar',
                  buttonColor: sectionColor,
                ),
                SubSectionButton(
                  label: 'Audio',
                  buttonColor: sectionColor,
                ),
                SubSectionButton(
                  label: 'Culture',
                  buttonColor: sectionColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubSectionButton extends StatelessWidget {
  final String label;
  final Color buttonColor;

  const SubSectionButton({
    required this.label,
    this.buttonColor = mainColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        shape: StadiumBorder(),
        foregroundColor: secondaryColor,
        backgroundColor: buttonColor,
      ),
      onPressed: () {
        // Implement button action here
      },
      child: Text(label),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PagePath(),
  ));
}
