import 'package:flutter/material.dart';

enum TestStatus { BEFORE_START, SHOW_QUESTION, SHOE_ANSWER, FINISHED }

class TestScreen extends StatefulWidget {
  final bool isIncludedMemorizedWords;

  TestScreen({required this.isIncludedMemorizedWords});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _numberOfQuestion = 0;

  String _txtQuestion = "テスト";

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
          SizedBox(
            height: 30.0,
          ),
          _numberOfQuestionsPart(),
          SizedBox(
            height: 50.0,
          ),
          _questionOfPart(),
          _answerCardPart(),
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
          style: TextStyle(fontSize: 14.0),
        ),
      ],
    );
  }

  //TODO 問題カード表示部分
  Widget _questionOfPart() {
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
