// 1) Create a new Flutter App (in this project) and output an AppBar and some text
// below it
// 2) Add a button which changes the text (to any other text of your choice)
// 3) Split the app into three widgets: App, TextControl & Text
import 'package:flutter/material.dart';
import 'package:flutter_assignment/customButton.dart';
import 'package:flutter_assignment/customText.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _messages = const [
    {'number': 'One'},
    {'number': 'Two'},
    {'number': 'Three'},
    {'number': 'Four'},
    {'number': 'Five'},
  ];

  var _messageIndex = 0;

  void _changeMessageIndex() {
    setState(() {
      _messageIndex += 1;
    });
  }

  void _resetMessageIndex() {
    setState(() {
      _messageIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MyApp Title'),
        ),
        body: _messageIndex < _messages.length
            ? Column(
                children: [
                  CustomText(_messageIndex,
                      _messages[_messageIndex]['number'] as String),
                  CustomButton('Change Text', _changeMessageIndex),
                ],
              )
            : CustomButton('Restart', _resetMessageIndex),
      ),
    );
  }
}
