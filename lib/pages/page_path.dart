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
        body: ListView(
          children: _subsections,
        ));
  }
}

// Widget buildCard(int index) => ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: SizedBox(
//         height: 150,
//         width: double.infinity,
//         child: _subsections[index],
//       ),
//     );

// Add more SubSections as needed
final List<SubSection> _subsections = [
  const SubSection(
    title: 'Subsection 1',
    sectionColor: Colors.teal,
    expandableWidgets: [
      ExpandableWidget(
        color: mainColor,
        title: 'Lesson 1',
        description: 'Description 1',
      ),
      ExpandableWidget(
        color: mainColor,
        title: 'Lesson 2',
        description: 'Description 2',
      )
    ],
  ),
  const SubSection(
    title: 'Subsection 2',
    sectionColor: Colors.orange,
    expandableWidgets: [
      ExpandableWidget(
        color: mainColor,
        title: 'Lesson 1',
        description: 'Description 1',
      ),
      ExpandableWidget(
        color: mainColor,
        title: 'Lesson 2',
        description: 'Description 2',
      ),
      ExpandableWidget(
        color: mainColor,
        title: 'Lesson 3',
        description: 'Description 3',
      )
    ],
  ),
  const SubSection(
    title: 'Subsection 3',
    expandableWidgets: [
      ExpandableWidget(
        color: mainColor,
        title: 'Lesson 1',
        description: 'Description 1',
      ),
      ExpandableWidget(
        color: mainColor,
        title: 'Lesson 2',
        description: 'Description 2',
      )
    ],
  ),
];

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
                style: const TextStyle(fontSize: 24, color: secondaryColor),
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

class ExpandableWidget extends StatefulWidget {
  final String title;
  final Color color;
  final String description;

  const ExpandableWidget(
      {super.key,
      required this.title,
      required this.color,
      required this.description});

  @override
  _ExpandableWidgetState createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _openSubPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          const SubPageSequence(), // Display sequence of sub-pages
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: _toggleExpanded,
          style: ElevatedButton.styleFrom(backgroundColor: widget.color),
          child: Text(widget.title),
        ),
        if (_isExpanded)
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.description),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => _openSubPage(context),
                  child: const Text('Begin'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class SubPageSequence extends StatefulWidget {
  const SubPageSequence({super.key});

  @override
  _SubPageSequenceState createState() => _SubPageSequenceState();
}

class _SubPageSequenceState extends State<SubPageSequence> {
  int _currentPageIndex = 0;
  final TextEditingController _answerController = TextEditingController();
  final String _realAnswer = "Answer 1"; // Placeholder answer
  String _answerFeedback = ''; // Feedback to display after checking

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Warning'),
            content: const Text(
                'All progress will be lost if you go back. Do you want to continue?'),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // Allow navigation back
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Stay on the page
                child: const Text('No'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _checkAnswer() {
    if (_answerController.text == _realAnswer) {
      setState(() {
        _answerFeedback = 'Correct';
      });
    } else {
      setState(() {
        _answerFeedback = 'Incorrect';
      });
    }
  }

  void _nextPage() {
    if (_currentPageIndex < 4) {
      setState(() {
        _currentPageIndex++;
        _answerController.clear();
        _answerFeedback = ''; // Clear feedback when moving to the next page
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('Question Pages')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Question ${_currentPageIndex + 1}'),
            const SizedBox(height: 16.0),
            const Text(
                'Placeholder Question Text'), // Replace with actual question text
            const SizedBox(height: 16.0),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                hintText: 'Enter your answer',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: const Text('Check'),
            ),
            const SizedBox(height: 8.0),
            Text(
              _answerFeedback,
              style: TextStyle(
                color: _answerFeedback == 'Correct' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _nextPage,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
