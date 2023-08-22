//chnage into a widget later
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Multiple Choice Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MultipleChoiceQuestion(
                  options: ['Thing 1', 'Thing 2', 'Thing 3'], correctIndex: 2)
            ],
          ),
        ),
      ),
    );
  }
}

//has one correct answer.
class MultipleChoiceQuestion extends StatelessWidget {
  List<String> options;

  int selectedIndex = -1;
  int correctIndex;

  MultipleChoiceQuestion(
      {super.key, required this.options, required this.correctIndex});

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

  bool check() {
    return correctIndex == selectedIndex;
  }
}

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

//////////////////////////////////////////////////////////////////////////////
///
///
///
///
///
///
///
///
///
///

class SoundButton extends StatefulWidget {
  final String buttonText;
  final String soundFilePath;
  final Color buttonColor;
  SoundButton(
      {required this.buttonText,
      required this.soundFilePath,
      required this.buttonColor});
  @override
  _SoundButtonState createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton> {
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

  void _playSound() async {
    await audioPlayer.play(widget.soundFilePath);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: widget.buttonColor),
      onPressed: _playSound,
      child: Text(widget.buttonText),
    );
  }
}

class QuestionAnswer {
  final String questionText;
  final String answer;
  QuestionAnswer({required this.questionText, required this.answer});
}

//Several types of questions.
//Text lessons, introduction
//Pronunciation
class TextToSpeech extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();

  TextToSpeech({super.key});

  speak(String text) async {
    await flutterTts.setLanguage(''); //en-US
    await flutterTts.setPitch(0);
    await await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          TextFormField(
            controller: textEditingController,
          ),
          ElevatedButton(
            onPressed: () => speak(textEditingController.text),
            child: Text('press to do tts'),
          )
        ]),
      ),
    );
  }
}
