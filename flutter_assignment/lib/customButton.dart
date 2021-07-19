import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback buttonHandler;

  CustomButton(this.buttonText, this.buttonHandler);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: buttonHandler,
        child: Text(buttonText),
      ),
    );
  }
}
