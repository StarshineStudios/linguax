import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../constants.dart';

//Extensions of this class store data about a QuestionPage.
//They are passed into QuestionPages to load data
abstract class QuestionData {
  final String prompt;
  QuestionData({Key? key, required this.prompt});
}

//Extensions of this class display a question page which display a question
//it stores the result
abstract class QuestionPage extends StatefulWidget {
  final Function(String) onUpdate;
  const QuestionPage({Key? key, required this.onUpdate}) : super(key: key);

  @override
  QuestionPageState<QuestionPage> createState();
}

abstract class QuestionPageState<T extends QuestionPage> extends State<T> {
  String result = 'NOT UPDATED';
  void checkAndUpdateResult();
}

////////////////////////////MULTIPLE CHOICE QUESTION////////////////////////////

//This stores the data for a multiple choice question
class MultipleChoiceQuestionData extends QuestionData {
  final List<String> options;
  final int correctIndex;

  MultipleChoiceQuestionData(
      {Key? key,
      required this.options,
      required this.correctIndex,
      required super.prompt})
      : super(key: key);
}

//This is a widget that simply displays a Column of multiple choices.
class MultipleChoiceQuestion extends QuestionPage {
  final MultipleChoiceQuestionData multipleChoiceQuestionData;
  final List<String> options;
  final int correctIndex;
  final String prompt;
  //the data from the questionData is loaded into the questionPage
  MultipleChoiceQuestion({
    super.key,
    required super.onUpdate,
    required this.multipleChoiceQuestionData,
  })  : prompt = multipleChoiceQuestionData.prompt,
        options = multipleChoiceQuestionData.options,
        correctIndex = multipleChoiceQuestionData.correctIndex;

  @override
  QuestionPageState<MultipleChoiceQuestion> createState() =>
      _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState
    extends QuestionPageState<MultipleChoiceQuestion> {
  int _selectedOptionIndex = -1;

  @override
  void checkAndUpdateResult() {
    setState(() {
      if (_selectedOptionIndex == widget.correctIndex) {
        result = 'Correct';
      } else {
        result = 'Incorrect';
      }
      widget.onUpdate(result); // Notify parent about the update
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(_selectedOptionIndex);
    return Column(
      children: [
        Column(
          children: [
            Text(widget.prompt, style: const TextStyle(fontSize: 30)),
            Column(
              children: widget.options.asMap().entries.map((entry) {
                int index = entry.key;
                String option = entry.value;
                bool isSelected = index == _selectedOptionIndex;

                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: NiceButton(
                    color: isSelected ? Colors.blue : mainColor,
                    inactiveColor: mainColorFaded,
                    onPressed: () {
                      setState(() {
                        _selectedOptionIndex = index;
                        checkAndUpdateResult();
                      });
                    },
                    active: true,
                    child: Container(
                      width: double.infinity,
                      height: 32,
                      alignment: Alignment.center,
                      child: Text(option),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}

////////////////////////////TYPED QUESTION//////////////////////////////////////
class TypedQuestionData extends QuestionData {
  final List<String> answers;

  TypedQuestionData({Key? key, required this.answers, required super.prompt})
      : super(key: key);
}

class TypedQuestion extends QuestionPage {
  final TypedQuestionData typedQuestionData;
  final TextEditingController textController = TextEditingController();

  final String prompt;
  final List<String> answers;
  TypedQuestion({
    super.key,
    required super.onUpdate,
    required this.typedQuestionData,
  })  : prompt = typedQuestionData.prompt,
        answers = typedQuestionData.answers;

  @override
  QuestionPageState<TypedQuestion> createState() => _TypedQuestionState();
}

class _TypedQuestionState extends QuestionPageState<TypedQuestion> {
  @override
  void checkAndUpdateResult() {
    setState(() {
      if (widget.answers.contains(widget.textController.text)) {
        result = 'Correct';
      } else {
        result = 'Incorrect';
      }
      widget.onUpdate(result); // Notify parent about the update
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.prompt, style: const TextStyle(fontSize: 30)),
        TextField(
          onChanged: (text) {
            checkAndUpdateResult();
          },
          style: const TextStyle(color: secondaryColor),
          controller: widget.textController,
          decoration: const InputDecoration(
              hintText: 'Type Answer',
              hintStyle: TextStyle(color: secondaryColor)),
        ),
      ],
    );
  }
}

//////////////////////AUDIO MULTIPLE CHOICE QUESTION////////////////////////////

//This stores the data for a multiple choice question
class AudioMultipleChoiceQuestionData extends QuestionData {
  final List<String> options;

  final List<String> soundFilePaths;
  final int correctIndex;

  AudioMultipleChoiceQuestionData(
      {Key? key,
      required this.options,
      required this.correctIndex,
      required this.soundFilePaths,
      required super.prompt})
      : super(key: key);
}

//This is a widget that simply displays a Column of multiple choices.
class AudioMultipleChoiceQuestion extends QuestionPage {
  final AudioMultipleChoiceQuestionData audioMultipleChoiceQuestionData;
  final List<String> options;
  final List<String> soundFilePaths;
  final int correctIndex;
  final String prompt;
  //the data from the questionData is loaded into the questionPage
  AudioMultipleChoiceQuestion({
    super.key,
    required super.onUpdate,
    required this.audioMultipleChoiceQuestionData,
  })  : prompt = audioMultipleChoiceQuestionData.prompt,
        options = audioMultipleChoiceQuestionData.options,
        soundFilePaths = audioMultipleChoiceQuestionData.soundFilePaths,
        correctIndex = audioMultipleChoiceQuestionData.correctIndex;

  @override
  QuestionPageState<AudioMultipleChoiceQuestion> createState() =>
      _AudioMultipleChoiceQuestionState();
}

class _AudioMultipleChoiceQuestionState
    extends QuestionPageState<AudioMultipleChoiceQuestion> {
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
    await audioPlayer.play(AssetSource(widget.soundFilePaths[index]));
  }

  @override
  void checkAndUpdateResult() {
    setState(() {
      if (_selectedOptionIndex == widget.correctIndex) {
        result = 'Correct';
      } else {
        result = 'Incorrect';
      }
      widget.onUpdate(result); // Notify parent about the update
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(_selectedOptionIndex);
    return Column(
      children: [
        Column(
          children: [
            Text(widget.prompt, style: const TextStyle(fontSize: 30)),
            Column(
              children: widget.options.asMap().entries.map((entry) {
                int index = entry.key;
                String option = entry.value;
                bool isSelected = index == _selectedOptionIndex;

                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: NiceButton(
                    color: isSelected ? Colors.blue : mainColor,
                    inactiveColor: mainColorFaded,
                    onPressed: () {
                      setState(() {
                        _selectedOptionIndex = index;
                        _playSound(index);
                        checkAndUpdateResult();
                      });
                    },
                    active: true,
                    child: Container(
                      width: double.infinity,
                      height: 32,
                      alignment: Alignment.center,
                      child: Text(option),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
