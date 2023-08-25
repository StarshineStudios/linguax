import 'package:flutter/material.dart';
import 'triangle.dart';
import '../../constants.dart';
import 'sub_page_sequence.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ExpandableWidget extends StatefulWidget {
  final String title;
  final Color color;
  final String description;
  final Box<dynamic> box;
  final String id;
  final List<Question> questions;
  final IconData icon;
  final List<String> dependencies;

  const ExpandableWidget(
      {super.key,
      required this.title,
      required this.color,
      required this.description,
      required this.questions,
      required this.id,
      this.icon = Icons.create,
      required this.dependencies,
      required this.box});

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
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
        bool finished =
            widget.box.get('${widget.id}finished', defaultValue: false);

        double accuracy =
            widget.box.get('${widget.id}accuracy', defaultValue: 0.0);

        List<bool> dependencyStatus = [];
        for (int i = 0; i < widget.dependencies.length; i++) {
          bool status = widget.box
              .get('${widget.dependencies[i]}finished', defaultValue: false);
          dependencyStatus.add(status);
        }

        bool locked = false;
        for (int i = 0; i < dependencyStatus.length; i++) {
          if (dependencyStatus[i] == false) {
            locked = true;
          }
        }

        if (accuracy > 1) {
          accuracy = 1;
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // if (_isExpanded)
                //   Row(
                //     children: [
                //       Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10),
                //           color: widget.color,
                //           border: Border.all(width: 0, color: widget.color),
                //         ),
                //         padding: const EdgeInsets.all(10),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             Text(
                //               widget.description,
                //               style: const TextStyle(
                //                   color: secondaryColor, fontFamily: 'Nunito'),
                //             ),
                //             NiceButton(
                //               onPressed: () => _openSubPage(context),
                //               child: Padding(
                //                 padding: const EdgeInsets.all(10.0),
                //                 child: Text(
                //                   finished ? 'Practice again' : 'Practice',
                //                   style: const TextStyle(color: secondaryColor),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       RotatedBox(
                //         quarterTurns: 1,
                //         child: TriangleClipPath(
                //           color: widget.color,
                //           width: 15,
                //           height: 10,
                //         ),
                //       ),
                //     ],
                //   ),

                CircularPercentIndicator(
                  radius: 60,
                  lineWidth: 10,
                  percent: accuracy,
                  progressColor: mainColor,
                  backgroundColor: mainColorFaded,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: NiceButton(
                      active: !locked,
                      onPressed: _toggleExpanded,
                      borderRadius: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          locked
                              ? Icons.lock
                              : (finished ? Icons.check : widget.icon),
                          size: 66,
                          color: secondaryColor,
                        ),
                      )),
                ),
                if (_isExpanded)
                  Row(
                    children: [
                      RotatedBox(
                        quarterTurns: 3,
                        child: TriangleClipPath(
                          color: widget.color,
                          width: 15,
                          height: 10,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: widget.color,
                          border: Border.all(width: 0, color: widget.color),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.description,
                              style: const TextStyle(
                                  color: secondaryColor, fontFamily: 'Nunito'),
                            ),
                            NiceButton(
                              onPressed: () => _openSubPage(context),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  finished ? 'Practice again' : 'Practice',
                                  style: const TextStyle(color: secondaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
