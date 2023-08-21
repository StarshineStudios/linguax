import 'package:flutter/material.dart';
import '../../test_files/question.dart';

class SubPageSequence extends StatefulWidget {
  final List<QuestionAnswer> questionAnswers; // Argument for the real answer

  const SubPageSequence({super.key, required this.questionAnswers});

  @override
  _SubPageSequenceState createState() =>
      _SubPageSequenceState(questionAnswers: questionAnswers);
}

class _SubPageSequenceState extends State<SubPageSequence> {
  int _currentPageIndex = 0;
  final TextEditingController _answerController = TextEditingController();

  bool isNextActive = false;
  String _answerFeedback = ''; //Correct or Incorrect

  final List<QuestionAnswer> questionAnswers; // Store the passed real answer

  _SubPageSequenceState(
      {required this.questionAnswers}); // Constructor that accepts real answer

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
    if (_currentPageIndex < questionAnswers.length - 1) {
      setState(() {
        _currentPageIndex++;
        _answerController.clear();
        _answerFeedback = ''; // Clear feedback when moving to the next page
        isNextActive = false;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

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
            Text(questionAnswers[_currentPageIndex].questionText),
            const SizedBox(height: 16.0),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                hintText: 'Enter your answer',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_answerController.text ==
                    questionAnswers[_currentPageIndex].answer) {
                  setState(() {
                    _answerFeedback = 'Correct';
                    isNextActive = true;
                  });
                } else {
                  setState(() {
                    _answerFeedback =
                        'Incorrect. Correct Answer: ${questionAnswers[_currentPageIndex].answer}. Type it in to proceed';
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
