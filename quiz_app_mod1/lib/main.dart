import 'package:flutter/material.dart';
import 'package:quiz_app_mod1/quiz.dart';
import 'package:quiz_app_mod1/result.dart';

import './quiz.dart';
import './result.dart';

//void main() {
//  runApp(MyApp());
//}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

//O UNDERLINE REPRESENTA UMA CLASSE PRIVADA, ACESSÍVEL SOMENTE
//NESTE ARQUIVO MAIN.DART
//O underline no metodo, representa que ele só é acessível dentro
//da classe _MyAppState
class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;
  var _totalScore = 0;
  //usamos Map abaixo key: value
  final _questions = const [
    {
      'questionText': 'What\'s your favorite animal?',
      'answers': [
        {'text': 'Rabbit', 'score': 5},
        {'text': 'Bird', 'score': 3},
        {'text': 'Elephant', 'score': 7},
        {'text': 'Lion', 'score': 10}
      ]
    },
    {
      'questionText': 'What\'s your favorite color?',
      'answers': [
        {'text': 'Yellow', 'score': 5},
        {'text': 'Green', 'score': 1},
        {'text': 'Red', 'score': 3},
        {'text': 'Blue', 'score': 7}
      ]
    },
    {
      'questionText': 'What\'s your favorite instructor?',
      'answers': [
        {'text': 'Vitor', 'score': 10},
        {'text': 'Leo', 'score': 7},
        {'text': 'Max', 'score': 5},
        {'text': 'Ana', 'score': 3}
      ]
    }
  ];

  void _answerChosen(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex = _questionIndex + 1;
    });
  }

  void _resetQuiz() {
    setState(() {
      _totalScore = 0;
      _questionIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App'),
        ),
        body: _questionIndex < _questions.length
            ? Quiz(
                answerChosen: _answerChosen,
                questionIndex: _questionIndex,
                questions: _questions,
              )
            : Result(_totalScore, _resetQuiz),
      ),
    );
  }
}
