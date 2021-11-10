import 'package:flutter/material.dart';
import 'package:my_own_flashcards/db/database.dart';
import 'package:my_own_flashcards/main.dart';

enum TestStatus { BEFORE_START, SHOW_QUESTION, SHOE_ANSWER, FINISHED }

class TestScreen extends StatefulWidget {
  final bool isIncludedMemorizedWords;

  TestScreen({required this.isIncludedMemorizedWords});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _numberOfQuestion = 0;
  String _txtQuestion = "テスト"; //TODO
  String _txtAnswer = "こたえ"; //TODO
  bool _isMemorized = false;

  bool _isQuestionCardVisible = false;
  bool _isAnswerCardVisible = false;
  bool _isCheckBoxVisible = false;
  bool _isFabVisible = false;

  List<Word> _testDataList = [];

  late TestStatus _testStatus;

  @override
  void initState() {
    super.initState();
    _getTestData();
  }

  void _getTestData() async {
    if (widget.isIncludedMemorizedWords) {
      _testDataList = await database.allWords;
    } else {
      _testDataList = await database.allWordsExcludedMemorized;
    }
    //テスト出題をランダムにする
    _testDataList.shuffle();
    _testStatus = TestStatus.BEFORE_START;

    setState(() {
      _isQuestionCardVisible = false;
      _isAnswerCardVisible = false;
      _isCheckBoxVisible = false;
      _isFabVisible = true;
      _numberOfQuestion = _testDataList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("かくにんテスト"),
        centerTitle: true,
      ),
      floatingActionButton: _isFabVisible
          ? FloatingActionButton(
              onPressed: () => _goNextStatus(),
              child: Icon(Icons.skip_next),
              tooltip: "次にすすむ",
            )
          : null,
      body: Column(
        children: [
          SizedBox(
            height: 50.0,
          ),
          _numberOfQuestionsPart(),
          SizedBox(
            height: 80.0,
          ),
          _questionOfPart(),
          SizedBox(
            height: 10.0,
          ),
          _answerCardPart(),
          SizedBox(
            height: 20.0,
          ),
          _isMemorizedCheckPart(),
        ],
      ),
    );
  }

  //残り問題数表示部分
  Widget _numberOfQuestionsPart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "のこりの問題数",
          style: TextStyle(fontSize: 18.0),
        ),
        SizedBox(
          width: 30.0,
        ),
        Text(
          _numberOfQuestion.toString(),
          style: TextStyle(fontSize: 22.0),
        ),
      ],
    );
  }

  //問題カード表示部分
  Widget _questionOfPart() {
    if (_isQuestionCardVisible) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/images/image_flash_question.png"),
          Text(
            _txtQuestion,
            style: TextStyle(color: Colors.grey[800], fontSize: 20.0),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  //こたえカード表示部分
  Widget _answerCardPart() {
    if (_isAnswerCardVisible) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/images/image_flash_answer.png"),
          Text(
            _txtAnswer,
            style: TextStyle(fontSize: 20.0),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  //暗記済みチェック部分
  Widget _isMemorizedCheckPart() {
    if (_isCheckBoxVisible) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: CheckboxListTile(
          title: Text(
            "暗記済みにする場合はチェックを入れてください",
            style: TextStyle(fontSize: 12.0),
          ),
          value: _isMemorized,
          onChanged: (value) {
            setState(
              () {
                _isMemorized = value!;
              },
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }

  _goNextStatus() {
    switch (_testStatus) {
      case TestStatus.BEFORE_START:
        _testStatus = TestStatus.SHOW_QUESTION;
        break;
      case TestStatus.SHOW_QUESTION:
        _testStatus = TestStatus.SHOE_ANSWER;
        break;
      case TestStatus.SHOE_ANSWER:
        if (_numberOfQuestion <= 0) {
          _testStatus = TestStatus.FINISHED;
        } else {
          _testStatus = TestStatus.SHOW_QUESTION;
        }
        break;
      case TestStatus.FINISHED:
        break;
    }
  }
}
