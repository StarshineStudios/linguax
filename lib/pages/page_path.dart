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

Widget buildCard(int index) => ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: _subsections[index],
      ),
    );

// Add more SubSections as needed
final List<SubSection> _subsections = [
  SubSection(
    title: 'Subsection 1',
    sectionColor: Colors.teal,
  ),
  SubSection(
    title: 'Subsection 2',
    sectionColor: Colors.orange,
  ),
  SubSection(
    title: 'Subsection 3',
    sectionColor: Colors.lime,
  ),
  SubSection(
    title: 'Subsection 4',
    sectionColor: Colors.pink,
  ),
  SubSection(
    title: 'Subsection 5',
    sectionColor: Colors.orange,
  ),
  SubSection(
    title: 'Subsection 6',
    sectionColor: Colors.purple,
  ),
  SubSection(title: 'Subsection 7'),
  SubSection(title: 'Subsection 8'),
  SubSection(title: 'Subsection 9'),
];

class SubSection extends StatelessWidget {
  final String title;
  final Color sectionColor;
  final List<String> buttons;

  final ScrollController _scrollController = ScrollController();

  SubSection({
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
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpandableWidget(
                    title: 'Vocabulary',
                    color: sectionColor,
                    description: 'Practice vocabulary',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpandableWidget(
                    title: 'Grammar',
                    color: sectionColor,
                    description: 'Practice grammar',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpandableWidget(
                    title: 'Audio',
                    color: sectionColor,
                    description: 'Practice audio exercises',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpandableWidget(
                    title: 'Culture',
                    color: sectionColor,
                    description: 'Practice culture',
                  ),
                ),
              ],
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

  ExpandableWidget(
      {required this.title, required this.color, required this.description});

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
      builder: (context) => SubPageSequence(), // Display sequence of sub-pages
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: _toggleExpanded,
          style: ElevatedButton.styleFrom(primary: widget.color),
          child: Text(widget.title),
        ),
        if (_isExpanded)
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.description),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => _openSubPage(context),
                  child: Text('Begin'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class SubPageSequence extends StatefulWidget {
  @override
  _SubPageSequenceState createState() => _SubPageSequenceState();
}

class _SubPageSequenceState extends State<SubPageSequence> {
  int _currentPageIndex = 0;

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Warning'),
            content: Text(
                'All progress will be lost if you go back. Do you want to continue?'),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // Allow navigation back
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Stay on the page
                child: Text('No'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _nextPage() {
    if (_currentPageIndex < 4) {
      setState(() {
        _currentPageIndex++;
      });
    } else {
      // Navigate back when all sub-pages are visited
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: Text('Sub Pages')),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Sub Page ${_currentPageIndex + 1}'),
              ],
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: _nextPage,
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
