import 'package:flutter/material.dart';
import 'package:flutter_test2/pages/page_1_path_things.dart/audio_widget.dart';
import 'triangle.dart';
import '../../constants.dart';

import 'package:hive_flutter/hive_flutter.dart';

class AudioLessonButton extends StatefulWidget {
  final String title;
  final Color color;
  final String description;
  final String assetSource;

  final Box<dynamic> box;
  final String id;

  //final List<Question> questions;

  const AudioLessonButton({
    super.key,
    required this.title,
    required this.color,
    required this.description,
    required this.assetSource,
    required this.box,
    required this.id,
  }); //NOTE TO FUTURE SELF: USE THIS TO PASS DATA//done

  @override
  State<AudioLessonButton> createState() => _AudioLessonButtonState();
}

class _AudioLessonButtonState extends State<AudioLessonButton> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _openSubPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AudioWidget(
        assetSource: widget.assetSource,
        id: widget.id,
        box: widget.box,
        title: widget.title,
      ), // Display an audio widget
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(generalBox).listenable(),
      builder: (BuildContext context, dynamic value, Widget? child) {
        bool finished = widget.box.get(widget.id, defaultValue: false);

        return Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: _toggleExpanded,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  foregroundColor: secondaryColor,
                ),
                child: Row(
                  children: [
                    Icon(finished
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(widget.title),
                  ],
                ),
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
                                    MaterialStateProperty.all(mainColor),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(1)),
                              ),
                              onPressed: () => _openSubPage(context),
                              child: Center(
                                widthFactor: 1.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    finished
                                        ? 'Listen again'
                                        : 'Begin Audio Lesson',
                                    style:
                                        const TextStyle(color: secondaryColor),
                                  ),
                                ),
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
