import 'package:flutter/material.dart';
import 'package:my_own_flashcards/db/database.dart';
import 'package:my_own_flashcards/main.dart';

import 'edit_screen.dart';

class WordListScreen extends StatefulWidget {
  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  List<Word> _wordList = [];

  @override
  void initState() {
    super.initState();
    _getAllWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("単語一覧"),
        centerTitle: true,
      ),
      //TODO body
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewWord(),
        child: Icon(Icons.add),
        tooltip: "新しい単語の登録",
      ),
    );
  }

  _addNewWord() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => EditScreen()));
  }

  void _getAllWords() async {
    _wordList = await database.allWords;
  }
}
