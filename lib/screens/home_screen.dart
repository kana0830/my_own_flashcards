import 'package:flutter/material.dart';
import 'package:my_own_flashcards/parts/button_with_icon.dart';
import 'package:my_own_flashcards/screens/test_screen.dart';
import 'package:my_own_flashcards/screens/word_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isIncludedMemorizedWords = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Image.asset("assets/images/image_title.png")),
            _titleText(),
            Divider(
              indent: 8.0,
              endIndent: 8.0,
              height: 70.0,
              color: Colors.white,
            ),
            ButtonWithIcon(
              onPressed: () => _startTestScreen(context),
              icon: Icon(Icons.play_arrow),
              label: "かくにんテストをする",
              color: Colors.brown,
            ),
            SizedBox(
              height: 20.0,
            ),
            _radioButtons(),
            SizedBox(
              height: 20.0,
            ),
            ButtonWithIcon(
                onPressed: () => _startWordListScreen(context),
                icon: Icon(Icons.list),
                label: "単語一覧を見る",
                color: Colors.grey),
            SizedBox(
              height: 80.0,
            ),
            Text(
              "powered by Kana",
              style: TextStyle(fontFamily: "Mont"),
            ),
            SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleText() {
    return Column(
      children: [
        Text(
          "私だけの単語帳",
          style: TextStyle(fontSize: 40.0),
        ),
        Text(
          "My Own Flashcard",
          style: TextStyle(fontSize: 24.0, fontFamily: "Mont"),
        ),
      ],
    );
  }

  Widget _radioButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: Column(
        children: [
          RadioListTile(
              title: Text(
                "暗記済みの単語を除外する",
                style: TextStyle(fontSize: 16.0),
              ),
              value: false,
              groupValue: isIncludedMemorizedWords,
              onChanged: (value) => _onRadioSelected(value)),
          RadioListTile(
              title: Text(
                "暗記済みの単語を含む",
                style: TextStyle(fontSize: 16.0),
              ),
              value: true,
              groupValue: isIncludedMemorizedWords,
              onChanged: (value) => _onRadioSelected(value)),
        ],
      ),
    );
  }

  _onRadioSelected(value) {
    setState(() {
      isIncludedMemorizedWords = value;
    });
  }

  _startWordListScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WordListScreen()));
  }

  _startTestScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TestScreen(
                  isIncludedMemorizedWords: isIncludedMemorizedWords,
                )));
  }
}
