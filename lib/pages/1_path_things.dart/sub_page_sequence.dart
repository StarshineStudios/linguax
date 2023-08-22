import 'package:flutter/material.dart';
import '../../test_files/question.dart';

//has one correct answer.
abstract class Question extends StatelessWidget {
  final String prompt;
  const Question({super.key, required this.prompt});

  // @override
  // Widget build(BuildContext context) {
  //   return Container();
  // }

  bool check();
  String hint();
}

//This displays a title with a MultipleChoiceWidget underneath.
class MultipleChoiceQuestion extends Question {
  List<String> options;
  int selectedIndex = -1;
  int correctIndex;

  MultipleChoiceQuestion(
      {super.key,
      required this.options,
      required this.correctIndex,
      required super.prompt});

  @override
  Widget build(BuildContext context) {
    return MultipleChoiceWidget(
      options: options,
      onOptionSelected: (index) {
        selectedIndex = index;
        //print('Selected option: ${index + 1}');
      },
    );
  }

  @override
  bool check() {
    return correctIndex == selectedIndex;
  }

  @override
  String hint() {
    return 'it might be at this index: $correctIndex';
  }
}

//This is a widget that simply displays a Column of multiple choices.
class MultipleChoiceWidget extends StatefulWidget {
  final List<String> options;
  final void Function(int) onOptionSelected;

  MultipleChoiceWidget({required this.options, required this.onOptionSelected});

  @override
  _MultipleChoiceWidgetState createState() => _MultipleChoiceWidgetState();
}

class _MultipleChoiceWidgetState extends State<MultipleChoiceWidget> {
  int _selectedOptionIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.asMap().entries.map((entry) {
        int index = entry.key;
        String option = entry.value;
        bool isSelected = index == _selectedOptionIndex;

        return ListTile(
          onTap: () {
            setState(() {
              _selectedOptionIndex = index;
              widget.onOptionSelected(index);
            });
          },
          title: Text(option),
          leading: isSelected
              ? Icon(Icons.radio_button_checked)
              : Icon(Icons.radio_button_unchecked),
        );
      }).toList(),
    );
  }
}

class TypedQuestion extends Question {
  List<String> answers;
  TextEditingController textController = TextEditingController();
  TypedQuestion({super.key, required this.answers, required super.prompt});

  @override
  bool check() {
    String userAnswer = textController.text;
    return answers.contains(userAnswer);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      decoration: const InputDecoration(
        hintText: 'Enter your answer',
      ),
    );
  }

  @override
  String hint() {
    return 'it might be one of these: $answers';
  }
}

////////////////////////////////////////////////////
class SubPageSequence extends StatefulWidget {
  final List<Question> questions; // Argument for the real answer

  const SubPageSequence({super.key, required this.questions});

  @override
  _SubPageSequenceState createState() =>
      _SubPageSequenceState(questions: questions);
}

class _SubPageSequenceState extends State<SubPageSequence> {
  int _currentPageIndex = 0;

  //final TextEditingController _answerController = TextEditingController();

  bool isNextActive = false;
  String _answerFeedback = ''; //Correct or Incorrect

  final List<Question> questions; // Store the passed real answer

  _SubPageSequenceState(
      {required this.questions}); // Constructor that accepts real answer

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Warning'),
            content: const Text(
                'All progress will be lost if you go back. Do you want to continue?'),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // Allow navigation back
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Stay on the page
                child: const Text('No'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _nextPage() {
    if (_currentPageIndex < questions.length - 1) {
      setState(() {
        _currentPageIndex++;
        //_answerController.clear();
        _answerFeedback = ''; // Clear feedback when moving to the next page
        isNextActive = false;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  // @override
  // void dispose() {
  //   _answerController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('Question Pages')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(questions[_currentPageIndex].prompt),
            questions[_currentPageIndex],

            // Text(questionAnswers[_currentPageIndex].questionText),
            // const SizedBox(height: 16.0),

            // const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (questions[_currentPageIndex].check()) {
                  setState(() {
                    _answerFeedback = 'Correct';
                    isNextActive = true;
                  });
                } else {
                  setState(() {
                    isNextActive = false; // TEMPORARY THING LJASKLJF:LADS
                    _answerFeedback =
                        'Incorrect. Hint: ${questions[_currentPageIndex].hint()}. fsljlfas';
                  });
                }
              },
              child: const Text('Check'),
            ),
            const SizedBox(height: 8.0),
            Text(
              _answerFeedback,
              style: TextStyle(
                color: _answerFeedback == 'Correct' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isNextActive
                  ? () {
                      _nextPage();
                    }
                  : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
