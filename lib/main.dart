import 'package:flutter/material.dart';
import 'package:my_own_flashcards/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "私だけの単語帳",
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
