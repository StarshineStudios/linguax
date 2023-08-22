import 'package:flutter/material.dart';
import '../../test_files/question.dart';
import 'expandable_widget.dart';
import '../1_page_path.dart';
import '../../constants.dart';
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
            options: ['1', '2', '3', '4', '5'],
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
            answers: ['two', 'Two', '2', 'Dos', 'dos'],
          ),
        ],
      ),
    ],
  ),
];
