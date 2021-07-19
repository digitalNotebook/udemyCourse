import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int totalScore;
  final Function resetQuiz;

  Result(this.totalScore, this.resetQuiz);

  String get resultPhase {
    String resultText;
    if (totalScore <= 8) {
      resultText = 'You are awesome and innocent';
    } else if (totalScore <= 12) {
      resultText = 'Pretty linkable';
    } else if (totalScore <= 16) {
      resultText = 'You are ... strange?!';
    } else {
      resultText = 'You are so bad';
    }
    print(resultText);
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            resultPhase,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: resetQuiz,
            child: Text('Restart Quiz!'),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.blue),
            ),
          )
        ],
      ),
    );
  }
}
