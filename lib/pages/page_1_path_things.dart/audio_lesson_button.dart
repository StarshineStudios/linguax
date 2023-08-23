import 'package:flutter/material.dart';
import 'package:flutter_test2/pages/page_1_path_things.dart/audio_widget.dart';
import 'triangle.dart';
import '../../constants.dart';
import 'sub_page_sequence.dart';

class AudioLessonButton extends StatefulWidget {
  final String title;
  final Color color;
  final String description;
  final String assetSource;

  //final List<Question> questions;

  const AudioLessonButton({
    super.key,
    required this.title,
    required this.color,
    required this.description,
    required this.assetSource,
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
          assetSource: widget.assetSource), // Display an audio widget
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _toggleExpanded,
              style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  foregroundColor: secondaryColor),
              child: Text(widget.title),
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
                                MaterialStateProperty.all(secondaryColor),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(1)),
                          ),
                          onPressed: () => _openSubPage(context),
                          child: Text(
                            'Begin Audio Lesson',
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
  }
}
