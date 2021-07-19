import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final int messageIndex;
  final String message;

  CustomText(this.messageIndex, this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(20),
      child: Text(
        message,
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }
}
