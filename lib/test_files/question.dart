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
              /*MultipleChoiceQuestion(
                  options: ['Thing 1', 'Thing 2', 'Thing 3'], correctIndex: 2)

                  */
            ],
          ),
        ),
      ),
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
