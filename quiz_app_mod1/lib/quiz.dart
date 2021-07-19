import 'package:flutter/material.dart';

import './question.dart';
import './answer.dart';

class Quiz extends StatelessWidget {
  final int questionIndex;
  final Function answerChosen;
  final List<Map<String, Object>> questions;

  Quiz({
    @required this.questionIndex,
    @required this.answerChosen,
    @required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(questions[questionIndex]['questionText'] as String),
        ...(questions[questionIndex]['answers'] as List<Map<String, Object>>)
            .map((answer) {
          return Answer(() => answerChosen(answer['score']), answer['text']);
        }).toList()
      ],
    );
  }
}
