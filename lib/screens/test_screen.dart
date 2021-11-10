import 'package:flutter/material.dart';

enum TestStatus { BEFORE_START, SHOW_QUESTION, SHOE_ANSWER, FINISHED }

class TestScreen extends StatefulWidget {
  final bool isIncludedMemorizedWords;

  TestScreen({required this.isIncludedMemorizedWords});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("かくにんテスト"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("Fab押した"), //TODO
        child: Icon(Icons.skip_next),
        tooltip: "次にすすむ",
      ),
      body: Column(
        children: [
          _numberOfQuestionsPart(),
          _questionOfPart(),
          _answerCardPart(),
          _isMemorizedCheckPart(),
        ],
      ),
    );
  }

  //TODO 残り問題数表示部分
  Widget _numberOfQuestionsPart() {
    return Container();
  }

  //TODO 問題カード表示部分
  Widget _questionOfPart() {
    return Container();
  }

  //TODO こたえカード表示部分
  Widget _answerCardPart() {
    return Container();
  }

  //TODO 暗記済みチェック部分
  Widget _isMemorizedCheckPart() {
    return Container();
  }
}
