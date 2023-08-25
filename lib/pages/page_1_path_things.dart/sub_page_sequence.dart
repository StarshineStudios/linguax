import 'package:flutter/material.dart';
import 'package:flutter_test2/constants.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

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
  final List<String> options;
  int selectedIndex = -1;
  final int correctIndex;

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

  const MultipleChoiceWidget(
      {super.key, required this.options, required this.onOptionSelected});

  @override
  State<MultipleChoiceWidget> createState() => _MultipleChoiceWidgetState();
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
              ? const Icon(Icons.radio_button_checked)
              : const Icon(Icons.radio_button_unchecked),
        );
      }).toList(),
    );
  }
}

class TypedQuestion extends Question {
  final List<String> answers;
  final TextEditingController textController = TextEditingController();

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

class AudioMultipleChoiceQuestion extends Question {
  final List<String> options;
  final List<String> soundFilePaths;
  int selectedIndex = -1;
  final int correctIndex;

  AudioMultipleChoiceQuestion(
      {super.key,
      required this.options,
      required this.correctIndex,
      required super.prompt,
      required this.soundFilePaths});

  @override
  Widget build(BuildContext context) {
    return AudioMultipleChoiceWidget(
      soundFilePaths: soundFilePaths,
      optionTexts: options,
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

//This is a widget that simply displays a Column of AUDIO multiple choices.
class AudioMultipleChoiceWidget extends StatefulWidget {
  final List<String> optionTexts;
  final List<String> soundFilePaths;
  final void Function(int) onOptionSelected;

  const AudioMultipleChoiceWidget(
      {super.key,
      required this.optionTexts,
      required this.onOptionSelected,
      required this.soundFilePaths});

  @override
  State<AudioMultipleChoiceWidget> createState() =>
      _AudioMultipleChoiceWidgetState();
}

class _AudioMultipleChoiceWidgetState extends State<AudioMultipleChoiceWidget> {
  int _selectedOptionIndex = -1;

  late AudioPlayer audioPlayer;
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void _playSound(int index) async {
    await audioPlayer.play(AssetSource(widget.soundFilePaths[
        _selectedOptionIndex])); //TODO: Update Audio Player thing. Most Code should be okay for now.
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.optionTexts.asMap().entries.map((entry) {
        int index = entry.key;
        String option = entry.value;
        bool isSelected = index == _selectedOptionIndex;

        return ListTile(
          onTap: () {
            setState(() {
              _selectedOptionIndex = index;
              widget.onOptionSelected(index);
              _playSound(index);
            });
          },
          title: Text(option),
          leading: isSelected
              ? const Icon(Icons.radio_button_checked)
              : const Icon(Icons.radio_button_unchecked),
        );
      }).toList(),
    );
  }
}

///////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
class SubPageSequence extends StatefulWidget {
  final List<Question> questions; // Argument for the real answer
  final String id;
  final Box<dynamic> box;
  const SubPageSequence(
      {super.key,
      required this.questions,
      required this.box,
      required this.id});

  @override
  State<SubPageSequence> createState() => _SubPageSequenceState();
}

//TODO: when there are many multiple choice questions after another, the option can appear selected even if there is nothing selected.
//Just rebuild the thing from the ground up with NiceButtons
class _SubPageSequenceState extends State<SubPageSequence> {
  int _currentPageIndex = 0;

  double correct = 0;
  //final TextEditingController _answerController = TextEditingController();

  bool isNextActive = false;
  String _answerFeedback = ''; //Correct or Incorrect

  //final List<Question> questions = widget.questions; // Store the passed real answer

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: mainColorBackground,
            title: const Text('Warning'),
            content: const Text(
                'All Progress will be lost. Do you really want to go back?'),
            actions: [
              NiceButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // Allow navigation back
                child: const Padding(
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                  child: Text('Yes'),
                ),
              ),
              NiceButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Stay on the page
                child: const Padding(
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                  child: Text('No'),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _nextPage() {
    if (_currentPageIndex < widget.questions.length - 1) {
      setState(() {
        _currentPageIndex++;
        //_answerController.clear();
        _answerFeedback = ''; // Clear feedback when moving to the next page
        isNextActive = false;
      });
    } else {
      setState(() {
        widget.box.put('${widget.id}finished', true);
        widget.box
            .put('${widget.id}accuracy', correct / widget.questions.length);
      });

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
        appBar: AppBar(
          backgroundColor: mainColor,
          foregroundColor: secondaryColor,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.questions[_currentPageIndex].prompt),
            widget.questions[_currentPageIndex],

            // Text(questionAnswers[_currentPageIndex].questionText),
            // const SizedBox(height: 16.0),

            // const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (widget.questions[_currentPageIndex].check()) {
                  setState(() {
                    if (_answerFeedback == '') {
                      correct++;
                    }
                    _answerFeedback = 'Correct';
                    isNextActive = true;
                  });
                } else {
                  setState(() {
                    isNextActive = false; // TEMPORARY THING LJASKLJF:LADS

                    _answerFeedback =
                        'Incorrect. Hint: ${widget.questions[_currentPageIndex].hint()}. fsljlfas';
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
