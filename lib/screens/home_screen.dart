import 'package:flutter/material.dart';
import 'package:my_own_flashcards/parts/button_with_icon.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              height: 30.0,
              color: Colors.white,
            ),
            ButtonWithIcon(
              onPressed: () => print("かくにんテスト"), //TODO
              icon: Icon(Icons.play_arrow),
              label: "かくにんテストをする",
              color: Colors.brown,
            ),
            //TODO ラジオボタン
            ButtonWithIcon(
                onPressed: () => print("単語一覧"),
                icon: Icon(Icons.list),
                label: "単語一覧を見る",
                color: Colors.grey),
            Text(
              "powered by Kana",
              style: TextStyle(fontFamily: "Mont"),
            )
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
}
