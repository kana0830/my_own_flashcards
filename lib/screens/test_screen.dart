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
  String _txtQuestion = "";
  String _txtAnswer = "";
  bool _isMemorized = false;

  bool _isQuestionCardVisible = false;
  bool _isAnswerCardVisible = false;
  bool _isCheckBoxVisible = false;
  bool _isFabVisible = false;

  List<Word> _testDataList = [];

  TestStatus? _testStatus;

  int _index = 0; //今何問目
  late Word _currentWord;

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
    _index = 0;

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
    return WillPopScope(
      onWillPop: () => _finishTestScreen(),
      child: Scaffold(
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
        body: Stack(
          children: [
            Column(
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
            _endMessage(),
          ],
        ),
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

  //テスト終了メッセージ
  Widget _endMessage() {
    if (_testStatus == TestStatus.FINISHED) {
      return Center(
        child: Text(
          "テスト終了",
          style: TextStyle(fontSize: 50.0),
        ),
      );
    } else {
      return Container();
    }
  }

  _goNextStatus() async {
    switch (_testStatus) {
      case TestStatus.BEFORE_START:
        _testStatus = TestStatus.SHOW_QUESTION;
        _showQuestion();
        break;
      case TestStatus.SHOW_QUESTION:
        _testStatus = TestStatus.SHOE_ANSWER;
        _showAnswer();
        break;
      case TestStatus.SHOE_ANSWER:
        await _updateMemorizedFlag();
        if (_numberOfQuestion <= 0) {
          setState(() {
            _isFabVisible = false;
            _testStatus = TestStatus.FINISHED;
          });
        } else {
          _testStatus = TestStatus.SHOW_QUESTION;
          _showQuestion();
        }
        break;
      case TestStatus.FINISHED:
        break;
    }
  }

  void _showQuestion() {
    _currentWord = _testDataList[_index];
    setState(
      () {
        _isQuestionCardVisible = true;
        _isAnswerCardVisible = false;
        _isCheckBoxVisible = false;
        _isFabVisible = true;
        _txtQuestion = _currentWord.strQuestion;
      },
    );
    _numberOfQuestion -= 1;
    _index += 1;
  }

  void _showAnswer() {
    setState(
      () {
        _isQuestionCardVisible = true;
        _isAnswerCardVisible = true;
        _isCheckBoxVisible = true;
        _isFabVisible = true;
        _txtAnswer = _currentWord.strAnswer;
        _isMemorized = _currentWord.isMemorized;
      },
    );
  }

  Future<void> _updateMemorizedFlag() async {
    var updateWord = Word(
        strQuestion: _currentWord.strQuestion,
        strAnswer: _currentWord.strAnswer,
        isMemorized: _isMemorized);
    await database.updateWord(updateWord);
  }

  Future<bool> _finishTestScreen() async {
    return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("テストの終了"),
            content: Text("テストを終了してもいいですか？"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("はい"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("いいえ"),
              ),
            ],
          ),
        ) ??
        false;
  }
}
