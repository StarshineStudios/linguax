import 'package:flutter/material.dart';
import 'package:flutter_test2/constants.dart';
import 'question.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

class SubPageSequence extends StatefulWidget {
  final List<QuestionData> questionDatas; //This is a double plural, not wrong!
  final String id;
  final Box<dynamic> box;
  const SubPageSequence(
      {super.key,
      required this.questionDatas,
      required this.box,
      required this.id});

  @override
  State<SubPageSequence> createState() => _SubPageSequenceState();
}

//TODO: when there are many multiple choice questions after another, the option can appear selected even if there is nothing selected.
//Just rebuild the thing from the ground up with NiceButtons
class _SubPageSequenceState extends State<SubPageSequence> {
  int _currentPageIndex = 0; //The current QuestionPage Displayed
  double correct = 0; //number of questions correct.
  bool isNextActive = false; //if the button to go to the next page is availible
  String _answerFeedback = ''; //Correct or Incorrect
  List<String> results = []; //how the user answered. right/wrong, etc

  List<QuestionPage> questionPages = [];

  void updateParentVariable(String newValue) {
    setState(() {
      isNextActive = true;
      print('NEXT IS ACTIVE');
      results.add(newValue);
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.questionDatas.length; i++) {
      QuestionData currentOne = widget.questionDatas[i];
      if (currentOne is MultipleChoiceQuestionData) {
        questionPages.add(MultipleChoiceQuestion(
            onUpdate: updateParentVariable,
            multipleChoiceQuestionData: currentOne));
      } else if (currentOne is TypedQuestionData) {
        questionPages.add(TypedQuestion(
            onUpdate: updateParentVariable, typedQuestionData: currentOne));
      } else {
        print('ERROR');
      }
    }
  }

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
    //when the page is a questionPage
    if (_currentPageIndex < questionPages.length - 1) {
      setState(() {
        _currentPageIndex++;
        _answerFeedback = '';
        isNextActive = false;
      });
      //when the page is the final question page (not final page)
    } else if (_currentPageIndex == questionPages.length - 1) {
      setState(() {
        _currentPageIndex++;
        _answerFeedback = '';
        isNextActive = true;
      });
      //when it is the final page
    } else {
      setState(() {
        for (int i = 0; i < questionPages.length; i++) {
          if (results[i] == 'Correct') {
            correct++;
          }
        }
        widget.box.put('${widget.id}finished', true);
        widget.box.put('${widget.id}accuracy', correct / questionPages.length);
      });

      Navigator.of(context).pop();
    }
  }

  Widget currentPage() {
    if (_currentPageIndex < questionPages.length) {
      return questionPages[_currentPageIndex];
    } else if (_currentPageIndex == questionPages.length) {
      List<Widget> texts = [];
      for (int i = 0; i < questionPages.length; i++) {
        texts.add(Text('Question $i: ${results[i]}'));
      }
      return Center(
        child: Column(
          children: texts,
        ),
      );
    }

    return Container(
      child: Text('this should not be here'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: mainColorBackground,
        appBar: AppBar(
          backgroundColor: mainColor,
          foregroundColor: secondaryColor,
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(bottom: 24, top: 24, left: 55, right: 55),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'hi',
                //widget.questions[_currentPageIndex].prompt,
                style: TextStyle(fontSize: 27),
              ),
              //questionPages[_currentPageIndex],
              currentPage(),
              // Text(questionAnswers[_currentPageIndex].questionText),
              // const SizedBox(height: 16.0),

              // const SizedBox(height: 16.0),
              // ElevatedButton(
              //   onPressed: () {
              //     if (widget.questions[_currentPageIndex].check()) {
              //       setState(() {
              //         if (_answerFeedback == '') {
              //           correct++;
              //         }
              //         _answerFeedback = 'Correct';
              //         isNextActive = true;
              //       });
              //     } else {
              //       setState(() {
              //         isNextActive = false; // TEMPORARY THING LJASKLJF:LADS

              //         _answerFeedback =
              //             'Incorrect. Hint: ${widget.questions[_currentPageIndex].hint()}. fsljlfas';
              //       });
              //     }
              //   },
              //   child: const Text(
              //     'Check',
              //     style: TextStyle(fontSize: 24),
              //   ),
              // ),
              const SizedBox(height: 8.0),
              Text(
                _answerFeedback,
                style: TextStyle(
                  color:
                      _answerFeedback == 'Correct' ? Colors.green : Colors.red,
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
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
