import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _wordListWidget(),
      ),
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
    setState(() {});
  }

  Widget _wordListWidget() {
    return ListView.builder(
      itemBuilder: (context, int position) => _wordItem(position),
      itemCount: _wordList.length,
    );
  }

  _wordItem(int position) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        title: Text("${_wordList[position].strQuestion}"),
        subtitle: Text(
          "${_wordList[position].strAnswer}",
          style: TextStyle(fontFamily: "Mont"),
        ),
        onLongPress: () => _deleteWord(_wordList[position]),
      ),
    );
  }

  _deleteWord(Word selectedWord) async {
    await database.deleteWord(selectedWord);
    Fluttertoast.showToast(
        msg: "削除が完了しました",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
    _getAllWords();
  }
}
