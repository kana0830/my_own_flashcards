import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_own_flashcards/db/database.dart';
import 'package:my_own_flashcards/main.dart';
import 'package:my_own_flashcards/screens/word_list_screen.dart';
import 'package:sqlite3/src/api/exception.dart';

enum EditStatus { ADD, EDIT }

class EditScreen extends StatefulWidget {
  final EditStatus status;
  final Word? word;

  EditScreen({required this.status, this.word});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  String _titleText = "";

  bool _isQuestionEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.status == EditStatus.ADD) {
      _titleText = "新しい単語の追加";
      _isQuestionEnabled = true;
      questionController.text = "";
      answerController.text = "";
    } else {
      _titleText = "登録した単語の修正";
      _isQuestionEnabled = false;
      questionController.text = widget.word!.strQuestion;
      answerController.text = widget.word!.strAnswer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backToWordListScreen(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titleText),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => _onWordRegistered(),
              icon: Icon(Icons.done),
              tooltip: "登録",
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30.0),
              Center(
                child: Text(
                  "問題と答えを入力して「登録」ボタンを押してください",
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              SizedBox(height: 30.0),
              //問題入力部分
              _questionInputPart(),
              SizedBox(height: 30.0),
              //答え入力部分
              _answerInputPart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _questionInputPart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Text(
            "問題",
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(height: 10.0),
          TextField(
            enabled: _isQuestionEnabled,
            controller: questionController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0),
          )
        ],
      ),
    );
  }

  Widget _answerInputPart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Text(
            "こたえ",
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: answerController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0),
          )
        ],
      ),
    );
  }

  Future<bool> _backToWordListScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => WordListScreen()));
    return Future.value(false);
  }

  _insertWord() async {
    if (questionController.text == "" || answerController.text == "") {
      Fluttertoast.showToast(
          msg: "問題と答えの両方を入力しないと登録できません",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      return;
    }
    var word = Word(
        strQuestion: questionController.text, strAnswer: answerController.text);
    try {
      await database.addWord(word);
    } on SqliteException catch (e) {
      Fluttertoast.showToast(
          msg: "この問題はすでに登録されていますので登録できません",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }

    questionController.clear();
    answerController.clear();
    Fluttertoast.showToast(
        msg: "登録完了しました",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }

  _onWordRegistered() {
    if (widget.status == EditStatus.ADD) {
      _insertWord();
    } else {
      _updateWord();
    }
  }

  void _updateWord() async {
    if (questionController.text == "" || answerController.text == "") {
      Fluttertoast.showToast(
          msg: "問題と答えの両方を入力しないと登録できません",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      return;
    }
    var word = Word(
        strQuestion: questionController.text, strAnswer: answerController.text);
    try {
      await database.updateWprd(word);
      _backToWordListScreen();
      Fluttertoast.showToast(
          msg: "修正が完了しました",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } on SqliteException catch (e) {
      Fluttertoast.showToast(
          msg: "何らかの問題が発生して登録できませんでした",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }
}
