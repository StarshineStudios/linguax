import 'package:flutter/material.dart';
import 'triangle.dart';
import '../../constants.dart';
import 'sub_page_sequence.dart';

import 'package:hive_flutter/hive_flutter.dart';

class ExpandableWidget extends StatefulWidget {
  final String title;
  final Color color;
  final String description;
  final Box<dynamic> box;
  final String id;
  final List<Question> questions;

  const ExpandableWidget(
      {super.key,
      required this.title,
      required this.color,
      required this.description,
      required this.questions,
      required this.id,
      required this.box});

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  bool _isExpanded = false;
  //late bool finished;

  // @override
  // void initState() {
  //   finished = widget.box.get(widget.id, defaultValue: false);
  //   super.initState();
  // }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _openSubPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SubPageSequence(
        questions: widget.questions,
        box: widget.box,
        id: widget.id,
      ), // Display sequence of sub-pages
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(generalBox).listenable(),
      builder: (BuildContext context, dynamic value, Widget? child) {
        bool finished = widget.box.get(widget.id, defaultValue: false);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _toggleExpanded,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: widget.color,
                        foregroundColor: secondaryColor),
                    child: Text(widget.title),
                  ),
                  Text(finished ? 'FINISHED' : 'NOT FINISHED')
                ],
              ),
              if (_isExpanded)
                Column(
                  children: [
                    TriangleClipPath(color: widget.color),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: widget.color,
                          border: Border.all(width: 0, color: widget.color),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.description,
                              style: const TextStyle(
                                  color: secondaryColor, fontFamily: 'Nunito'),
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(secondaryColor),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(1)),
                              ),
                              onPressed: () => _openSubPage(context),
                              child: Text(
                                finished ? 'Repeat lesson' : 'Begin',
                                style: TextStyle(color: widget.color),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
