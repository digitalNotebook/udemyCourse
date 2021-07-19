import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  //caso não funcione usar final VoidCallback selectedHandler;

  //armazenamos um pointer da função da outra classe (widget)
  final Function selectHandler;
  final String answer;

  Answer(this.selectHandler, this.answer);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            primary: Colors.blue,
            side: BorderSide(
              color: Colors.blue,
            )),
        child: Text(answer),
        onPressed: selectHandler,
      ),
    );
  }
}
