import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          //Sem o expanded o textfield ocupará o máximo de espaço possível
          //o que ocasionará um erro
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            //o botão só fica disponível quando uma letra for digitada
            onPressed: _enteredMessage.trim().isEmpty ? null : () {},
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
