import 'package:flutter/material.dart';
import 'package:flutter_test2/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'question.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

class _SubPageSequenceState extends State<SubPageSequence> {
  int _currentPageIndex = 0; //The current QuestionPage Displayed
  double correct = 0; //number of questions correct.
  bool isCheckActive = false; //if the button to go to the next page is
  bool isCheckNext = false; //if check button is a next
  String feedback = '';
  Color feedbackColor = Colors.black;
  int numberOfHints = 0;
  List<List<String>> listsOfHints = [];

  //String _answerFeedback = ''; //Correct or Incorrect
  List<String> results = []; //how the user answered. right/wrong, etc
  List<String> firstTryResults = [];

  List<Widget> pages = [];

  final PageController _controller = PageController();
  void updateParentVariable(String newValue) {
    setState(() {
      isCheckActive = true;
      if (results.length >= _currentPageIndex + 1) {
        results[_currentPageIndex] = newValue;
      } else {
        results.add(newValue);
      }

      //print(results);
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.questionDatas.length; i++) {
      QuestionData currentOne = widget.questionDatas[i];
      listsOfHints.add(currentOne.hints);
      if (currentOne is MultipleChoiceQuestionData) {
        pages.add(MultipleChoiceQuestion(
            onUpdate: updateParentVariable,
            multipleChoiceQuestionData: currentOne));
        //print(currentOne.prompt);
      } else if (currentOne is TypedQuestionData) {
        pages.add(TypedQuestion(
            onUpdate: updateParentVariable, typedQuestionData: currentOne));
      } else if (currentOne is AudioMultipleChoiceQuestionData) {
        pages.add(AudioMultipleChoiceQuestion(
            onUpdate: updateParentVariable,
            audioMultipleChoiceQuestionData: currentOne));
      } else {
        //print('ERROR');
      }
    }

    pages.add(Container());
    //solely to prevent some glitches when the hints list is not logn enough
    listsOfHints.add([]);
  }

  //final List<Question> questions = widget.questions; // Store the passed real answer

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: mainColorBackground,
            title: const Text('Warning'),
            content: const Text(
              'All Progress will be lost. Do you really want to go back?',
              style: normalStyle,
            ),
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

  void _checkAnswer() {
    if (firstTryResults.length >= _currentPageIndex + 1) {
      //WILL NOT BE REASSIGNED
      //firstTryResults[_currentPageIndex] = newValue;
    } else {
      firstTryResults.add(results[_currentPageIndex]);
    }

    setState(() {
      if (results[results.length - 1] == 'Incorrect') {
        isCheckActive = false;
        feedback = 'Incorrect. Try again';
        _nextHint();
        feedbackColor = Colors.red;
      } else {
        if (firstTryResults[firstTryResults.length - 1] == 'Incorrect') {
          feedback = 'You needed some help, but you got it!';
          isCheckNext = true;
          feedbackColor = Colors.green;
        } else {
          feedback = 'Correct! Move on to the next question';
          isCheckNext = true;
          feedbackColor = Colors.green;
        }
      }
    });
  }

  void _nextPage() {
    numberOfHints = 0;
    feedback = '';
    //when the page is a questionPage
    if (_currentPageIndex < pages.length - 2) {
      setState(() {
        _controller.nextPage(
            duration: const Duration(microseconds: 400), curve: Curves.linear);
        _currentPageIndex++;
        //_answerFeedback = '';
        isCheckActive = false;
        isCheckNext = false;
      });
      //when the page is the final question page (not final page)
    } else if (_currentPageIndex == pages.length - 2) {
      setState(() {
        _controller.nextPage(
            duration: const Duration(microseconds: 400), curve: Curves.linear);
        _currentPageIndex++;
        //_answerFeedback = '';
        isCheckActive = true;
        isCheckNext = true;

        List<Widget> resultTexts = [];
        resultTexts.add(const Text(
          'Results \n (First answer attempt)',
          textAlign: TextAlign.center,
          style: headingStyle3,
        ));
        for (int i = 0; i < firstTryResults.length; i++) {
          resultTexts.add(Text('Question ${i + 1}: ${firstTryResults[i]}'));
        }
        pages[pages.length - 1] = Container(
          alignment: Alignment.center,
          child: Column(
            children: resultTexts,
          ),
        );
      });
    } else {
      setState(() {
        for (int i = 0; i < results.length; i++) {
          if (results[i] == 'Correct') {
            correct++;
          }
        }
        widget.box.put('${widget.id}finished', true);
        widget.box.put('${widget.id}accuracy', correct / results.length);
      });

      Navigator.of(context).pop();
    }
  }

  void _nextHint() {
    if (numberOfHints < listsOfHints[_currentPageIndex].length) {
      setState(() {
        numberOfHints++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> hintTexts = [];
    for (int i = 0; i < numberOfHints; i++) {
      hintTexts.add(Text(
        'Hint ${i + 1}: \n ${listsOfHints[_currentPageIndex][i]}',
        style: normalStyle,
      ));
    }

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
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 400,
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _controller,
                        children: pages,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: Column(children: hintTexts),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: const Alignment(0, 0.75),
                child: Column(
                  children: [
                    feedback == ''
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(defaultRadius),
                                  color: feedbackColor),
                              padding: const EdgeInsets.all(9.0),
                              child: Text(
                                feedback,
                                textAlign: TextAlign.center,
                                style: normalStyle,
                              ),
                            ),
                          ),
                    Container(
                      alignment: const Alignment(0, 0.65),
                      child: Text('Do ${pages.length - 1} questions'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //This thing will glitch out if it is on the results page because the hints dont exist.
                        //for a safety measure i added an empty list of hints at the end
                        //but this is a pretty disgusting solution tbh
                        _currentPageIndex < pages.length - 1
                            ? NiceButton(
                                onPressed: _nextHint,
                                color: numberOfHints <=
                                        listsOfHints[_currentPageIndex].length -
                                            1
                                    ? mainColor
                                    : Colors.grey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(numberOfHints <
                                          listsOfHints[_currentPageIndex]
                                                  .length -
                                              1
                                      ? 'Show Hint'
                                      : numberOfHints ==
                                              listsOfHints[_currentPageIndex]
                                                      .length -
                                                  1
                                          ? 'Show Answer'
                                          : 'No Hints Left'),
                                ),
                              )
                            : Container(),
                        SmoothPageIndicator(
                          controller: _controller,
                          count: pages.length,
                          effect: const ScaleEffect(
                              scale: 1.5,
                              dotHeight: 10,
                              dotWidth: 10,
                              dotColor: mainColor,
                              activeDotColor: mainColor,
                              activePaintStyle: PaintingStyle.stroke,
                              strokeWidth: 2),
                        ),
                        //next or done
                        NiceButton(
                          onPressed: isCheckNext ? _nextPage : _checkAnswer,
                          color: isCheckActive || isCheckNext
                              ? mainColor
                              : Colors.grey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_currentPageIndex == pages.length - 1
                                ? 'Finish'
                                : isCheckNext
                                    ? 'Next'
                                    : 'Check'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
