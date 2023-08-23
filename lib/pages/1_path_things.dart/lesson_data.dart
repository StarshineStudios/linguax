import 'package:flutter/material.dart';
import 'expandable_widget.dart';
import '../page_1_path.dart';
import 'sub_page_sequence.dart';

List<SubSection> subsections = [
  SubSection(
    title: 'Subsection 1',
    sectionColor: Colors.teal,
    expandableWidgets: [
      ExpandableWidget(
        color: Colors.teal,
        title: 'Lesson 1',
        description: 'Description 1',
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
    expandableWidgets: [
      ExpandableWidget(
        color: Colors.teal,
        title: 'Lesson 1',
        description: 'Description 1',
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
