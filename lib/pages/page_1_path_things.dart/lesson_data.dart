import 'package:flutter/material.dart';
import 'package:flutter_test2/pages/page_1_path_things.dart/audio_lesson_button.dart';
import 'expandable_widget.dart';
import 'sub_page_sequence.dart';
import 'subsection.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'question.dart';

List<SubSection> subsections(
  Box<dynamic> box,
  //Function(String) updateParentVariable,
) {
  Color color1 = const Color.fromARGB(150, 0, 0, 0);
  Color color2 = const Color.fromARGB(150, 0, 0, 0);
  return [
    SubSection(
      sectionColor: color1,
      audioLessonButton: AudioLessonButton(
        dependencies: const [],
        title: 'Lesson 1',
        color: color1,
        imageCaption: 'Introduction to -are verbs',
        audioSource: 'orchestra-string-section-tune-SBA-300120703.mp3',
        imageSource: 'assets/s3___eu-west-1_dlcs-storage_2_8_V0044790.jpg',
        box: box,
        id: '1al',
      ),
      expandableWidgets: [
        ExpandableWidget(
          dependencies: const ['1al'],
          color: color1,
          title: 'Reading Excersise',
          description: 'Description 1',
          id: '11',
          box: box,
          questionDatas: [
            MultipleChoiceQuestionData(
              prompt: 'What is one plus two?',
              correctIndex: 2,
              options: const ['1', '2', '3', '4', '5'],
            ),
            MultipleChoiceQuestionData(
              prompt: 'What is one plus two?',
              correctIndex: 2,
              options: const ['1', '2', '3', '4', '5'],
            ),
            MultipleChoiceQuestionData(
              prompt: 'What is one plus two?',
              correctIndex: 2,
              options: const ['1', '2', '3', '4', '5'],
            ),
            MultipleChoiceQuestionData(
              prompt: 'What is one plus two?',
              correctIndex: 2,
              options: const ['1', '2', '3', '4', '5'],
            ),
          ],
        ),
        ExpandableWidget(
          dependencies: const ['11'],
          color: color1,
          title: 'Listening Excersise',
          description: 'Description 2',
          id: '12',
          box: box,
          questionDatas: [
            TypedQuestionData(
              prompt: 'What is one plus one?',
              answers: const ['two', 'Two', '2', 'Dos', 'dos'],
            ),
          ],
        ),
      ],
    ),
    SubSection(
      sectionColor: color2,
      audioLessonButton: AudioLessonButton(
        dependencies: const ['1al', '11', '12'],
        title: 'Lesson 2',
        color: color2,
        imageCaption: 'SECOND AUDIO LESSON',
        audioSource: 'wild-jams-SBA-346689705.mp3',
        imageSource:
            'assets/640px-Cole_Thomas_The_Consummation_The_Course_of_the_Empire_1836.jpg',
        box: box,
        id: '2al',
      ),
      expandableWidgets: [
        ExpandableWidget(
          dependencies: const ['2al'],
          color: color2,
          title: 'Listening Excersise',
          description: 'Description 1',
          id: '21',
          box: box,
          questionDatas: [
            AudioMultipleChoiceQuestionData(
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
          dependencies: const ['21'],
          color: color2,
          title: 'Writing Excersise',
          description: 'Description 2',
          id: '22',
          box: box,
          questionDatas: [
            TypedQuestionData(
              prompt: 'What is one plus one?',
              answers: const ['two', 'Two', '2', 'Dos', 'dos'],
            ),
          ],
        ),
      ],
    ),
    SubSection(
      sectionColor: color2,
      audioLessonButton: AudioLessonButton(
        dependencies: const ['2al', '21', '22'],
        title: 'Lesson 3',
        color: color2,
        imageCaption: 'SECOND AUDIO LESSON',
        audioSource: 'orchestra-string-section-tune-SBA-300120703.mp3',
        imageSource: 'assets/ddac797ee160d91a5e605ac02b4bca8edbcfd87a.jpg',
        box: box,
        id: '3al',
      ),
      expandableWidgets: [
        ExpandableWidget(
          dependencies: const ['3al'],
          color: color2,
          title: 'Listening Excersise',
          description: 'Description 1',
          id: '31',
          box: box,
          questionDatas: [
            AudioMultipleChoiceQuestionData(
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
          dependencies: const ['31'],
          color: color2,
          title: 'Writing Excersise',
          description: 'Description 2',
          id: '32',
          box: box,
          questionDatas: [
            TypedQuestionData(
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
