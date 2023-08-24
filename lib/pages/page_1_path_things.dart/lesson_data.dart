import 'package:flutter/material.dart';
import 'package:flutter_test2/pages/page_1_path_things.dart/audio_lesson_button.dart';
import 'expandable_widget.dart';
import 'sub_page_sequence.dart';
import 'subsection.dart';

import 'package:hive_flutter/hive_flutter.dart';

List<SubSection> subsections(Box<dynamic> box) {
  return [
    SubSection(
      title: 'Subsection 1',
      sectionColor: Colors.teal,
      audioLessonButton: const AudioLessonButton(
        title: 'AUDIO LESSON 1',
        color: Colors.teal,
        description: 'FIRST AUDIO LESSON',
        assetSource: 'orchestra-string-section-tune-SBA-300120703.mp3',
      ),
      expandableWidgets: [
        ExpandableWidget(
          color: Colors.teal,
          title: 'Lesson 1',
          description: 'Description 1',
          id: '11',
          box: box,
          questions: [
            MultipleChoiceQuestion(
              prompt: 'What is one plus two?',
              correctIndex: 2,
              options: const ['1', '2', '3', '4', '5'],
            ),
          ],
        ),
        ExpandableWidget(
          color: Colors.teal,
          title: 'Lesson 2',
          description: 'Description 2',
          id: '12',
          box: box,
          questions: [
            TypedQuestion(
              prompt: 'What is one plus one?',
              answers: const ['two', 'Two', '2', 'Dos', 'dos'],
            ),
          ],
        ),
      ],
    ),
    SubSection(
      title: 'Subsection 2',
      sectionColor: Colors.teal,
      audioLessonButton: const AudioLessonButton(
          title: 'AUDIO LESSON 2',
          color: Colors.teal,
          description: 'SECOND AUDIO LESSON',
          assetSource: 'orchestra-string-section-tune-SBA-300120703.mp3'),
      expandableWidgets: [
        ExpandableWidget(
          color: Colors.teal,
          title: 'Lesson 1',
          description: 'Description 1',
          id: '21',
          box: box,
          questions: [
            AudioMultipleChoiceQuestion(
              prompt: 'What is 3 minus 1',
              correctIndex: 1,
              options: const [
                'sound 1',
                'sound 2',
                'sound 3',
                'sound 4',
                'sound 5'
              ],
              soundFilePaths: const [
                'speaking-one-female-SBA-300283667.mp3',
                'speaking-two-female-SBA-300286110.mp3',
                'speaking-three-female-SBA-300286457.mp3',
                'speaking-four-female-SBA-300286460.mp3',
                'speaking-five-female-SBA-300287067.mp3',
              ],
            ),
          ],
        ),
        ExpandableWidget(
          color: Colors.teal,
          title: 'Lesson 2',
          description: 'Description 2',
          id: '22',
          box: box,
          questions: [
            TypedQuestion(
              prompt: 'What is one plus one?',
              answers: const ['two', 'Two', '2', 'Dos', 'dos'],
            ),
          ],
        ),
      ],
    ),
  ];
}
