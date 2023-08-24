import 'package:flutter/material.dart';
import 'package:flutter_test2/pages/page_1_path_things.dart/audio_lesson_button.dart';
import 'expandable_widget.dart';
import 'sub_page_sequence.dart';
import 'subsection.dart';

import 'package:hive_flutter/hive_flutter.dart';

List<SubSection> subsections(Box<dynamic> box) {
  Color color1 = const Color.fromARGB(150, 0, 0, 0);
  Color color2 = const Color.fromARGB(150, 0, 0, 0);
  return [
    SubSection(
      imagePath: 'assets/s3___eu-west-1_dlcs-storage_2_8_V0044790.jpg',
      title: 'Chapter I',
      sectionColor: color1,
      audioLessonButton: AudioLessonButton(
        title: 'Lesson',
        color: color1,
        description: 'Introduction to -are verbs',
        assetSource: 'orchestra-string-section-tune-SBA-300120703.mp3',
        box: box,
        id: '1al',
      ),
      expandableWidgets: [
        ExpandableWidget(
          color: color1,
          title: 'Reading Excersise',
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
          color: color1,
          title: 'Listening Excersise',
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
      imagePath:
          'assets/640px-Cole_Thomas_The_Consummation_The_Course_of_the_Empire_1836.jpg',
      title: 'Chapter II',
      sectionColor: color2,
      audioLessonButton: AudioLessonButton(
        title: 'Lesson',
        color: color2,
        description: 'SECOND AUDIO LESSON',
        assetSource: 'wild-jams-SBA-346689705.mp3',
        box: box,
        id: '2al',
      ),
      expandableWidgets: [
        ExpandableWidget(
          color: color2,
          title: 'Listening Excersise',
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
          color: color2,
          title: 'Writing Excersise',
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
    SubSection(
      imagePath: 'assets/ddac797ee160d91a5e605ac02b4bca8edbcfd87a.jpg',
      title: 'Chapter III',
      sectionColor: color2,
      audioLessonButton: AudioLessonButton(
        title: 'Lesson',
        color: color2,
        description: 'SECOND AUDIO LESSON',
        assetSource: 'orchestra-string-section-tune-SBA-300120703.mp3',
        box: box,
        id: '3al',
      ),
      expandableWidgets: [
        ExpandableWidget(
          color: color2,
          title: 'Listening Excersise',
          description: 'Description 1',
          id: '31',
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
          color: color2,
          title: 'Writing Excersise',
          description: 'Description 2',
          id: '32',
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

List<Word> vocabulary(int subsection) {
  return [];
}

class Word {
  final String lemma;
  final String language;
  final int etymology;

  Word(this.lemma, this.language, this.etymology);
}

class LatinWord extends Word {
  // Constructor of LatinWord
  LatinWord(String lemma, int etymology) : super(lemma, 'Latin', etymology);
}
