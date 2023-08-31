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
  bool isNextActive = false; //if the button to go to the next page is availible
  //String _answerFeedback = ''; //Correct or Incorrect
  List<String> results = []; //how the user answered. right/wrong, etc

  List<Widget> pages = [];

  final PageController _controller = PageController();
  void updateParentVariable(String newValue) {
    setState(() {
      isNextActive = true;
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
    if (_currentPageIndex < pages.length - 2) {
      setState(() {
        _controller.nextPage(
            duration: const Duration(microseconds: 100), curve: Curves.linear);
        _currentPageIndex++;
        //_answerFeedback = '';
        isNextActive = false;
      });
      //when the page is the final question page (not final page)
    } else if (_currentPageIndex == pages.length - 2) {
      setState(() {
        _controller.nextPage(
            duration: const Duration(microseconds: 100), curve: Curves.linear);
        _currentPageIndex++;
        //_answerFeedback = '';
        isNextActive = true;
        print('test');

        List<Widget> resultTexts = [];
        for (int i = 0; i < results.length; i++) {
          resultTexts.add(Text(results[i]));
        }
        pages[pages.length - 1] = Container(
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
        widget.box.put('${widget.id}accuracy', correct / pages.length);
      });

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    //controller to keep track of pages
    bool onLastPage = false;
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
          child: Stack(
            children: [
              PageView(
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    onLastPage = index == pages.length;
                  });
                },
                controller: _controller,
                children: pages,
              ),
              Container(
                alignment: const Alignment(0, 0.75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // //TEMP BUTTON
                    // NiceButton(
                    //   onPressed: _nextPage,
                    //   child: Text('Skip'),
                    // ),
                    SmoothPageIndicator(
                        controller: _controller, count: pages.length),
                    //next or done
                    NiceButton(
                      onPressed: isNextActive ? _nextPage : () {},
                      color: isNextActive ? mainColor : Colors.grey,
                      child: Text(onLastPage ? 'Finish' : 'Next'),
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


// Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Text(
//                 'hi',
//                 //widget.questions[_currentPageIndex].prompt,
//                 style: TextStyle(fontSize: 27),
//               ),
//               //questionPages[_currentPageIndex],
//               currentPage(),
//               // Text(questionAnswers[_currentPageIndex].questionText),
//               // const SizedBox(height: 16.0),

//               // const SizedBox(height: 16.0),
//               // ElevatedButton(
//               //   onPressed: () {
//               //     if (widget.questions[_currentPageIndex].check()) {
//               //       setState(() {
//               //         if (_answerFeedback == '') {
//               //           correct++;
//               //         }
//               //         _answerFeedback = 'Correct';
//               //         isNextActive = true;
//               //       });
//               //     } else {
//               //       setState(() {
//               //         isNextActive = false; // TEMPORARY THING LJASKLJF:LADS

//               //         _answerFeedback =
//               //             'Incorrect. Hint: ${widget.questions[_currentPageIndex].hint()}. fsljlfas';
//               //       });
//               //     }
//               //   },
//               //   child: const Text(
//               //     'Check',
//               //     style: TextStyle(fontSize: 24),
//               //   ),
//               // ),
//               const SizedBox(height: 8.0),
//               Text(
//                 _answerFeedback,
//                 style: TextStyle(
//                   color:
//                       _answerFeedback == 'Correct' ? Colors.green : Colors.red,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: isNextActive
//                     ? () {
//                         _nextPage();
//                       }
//                     : null,
//                 child: const Text(
//                   'Next',
//                   style: TextStyle(fontSize: 24),
//                 ),
//               ),
//             ],
//           ),