import 'package:flutter/material.dart';
import 'package:flutter_test2/pages/page_1_path_things.dart/audio_widget.dart';

import '../../constants.dart';

import 'package:hive_flutter/hive_flutter.dart';
import '../../constants.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AudioLessonButton extends StatefulWidget {
  final String title;
  final Color color;
  final String imageCaption;
  final String audioSource;
  final String imageSource;
  final Box<dynamic> box;
  final List<String> dependencies;
  final String id;

  const AudioLessonButton({
    super.key,
    required this.title,
    required this.color,
    required this.imageCaption,
    required this.audioSource,
    required this.box,
    required this.id,
    required this.dependencies,
    required this.imageSource,
  });

  @override
  State<AudioLessonButton> createState() => _AudioLessonButtonState();
}

class _AudioLessonButtonState extends State<AudioLessonButton> {
  //bool _isExpanded = false;

  // void _toggleExpanded() {
  //   setState(() {
  //     _isExpanded = !_isExpanded;
  //   });
  // }

  void _openSubPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AudioWidget(
        assetSource: widget.audioSource,
        id: widget.id,
        box: widget.box,
        title: widget.title,
        imageSource: widget.imageSource,
        imageCaption: widget.imageCaption,
      ), // Display an audio widget
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ValueListenableBuilder(
        valueListenable: Hive.box(generalBox).listenable(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          bool finished =
              widget.box.get('${widget.id}finished', defaultValue: false);
          double percent =
              widget.box.get('${widget.id}position', defaultValue: 0) /
                  widget.box.get('${widget.id}duration', defaultValue: 1);
          //print(0 / 0);

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

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(defaultRadius),
              color: locked ? mainColorFaded : mainColor,
            ),
            padding: const EdgeInsets.all(defaultPadding),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.imageSource),
                  colorFilter: locked
                      ? const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        )
                      : const ColorFilter.mode(mainColor, BlendMode.softLight),

                  ///makes the image black and white if locked
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(defaultRadius),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.title,
                          style: headingStyle2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 33, right: 33),
                        alignment: Alignment.centerRight,
                        child: CircularPercentIndicator(
                          radius: 60,
                          lineWidth: 10,
                          percent: percent,
                          progressColor: mainColor,
                          backgroundColor: mainColorFaded,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: NiceButton(
                            active: !locked,
                            borderRadius: 100,
                            onPressed: () => _openSubPage(context),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                locked
                                    ? Icons.lock
                                    : (finished
                                        ? Icons.check
                                        : Icons.play_arrow),
                                size: 66,
                                color: secondaryColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
