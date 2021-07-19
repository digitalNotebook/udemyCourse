import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/adaptive_flatbutton.dart';

//Irá holdar nossos textfields
class NewTransaction extends StatefulWidget {
  final Function transactionHandler;

  NewTransaction(this.transactionHandler) {
    print('NewTransaction Constructor');
  }

  @override
  _NewTransactionState createState() {
    print('_NewTransactionState createState');
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  _NewTransactionState() {
    print('_NewTransactionState constructor');
  }

  //executamos o initState aqui e na classe pai State
  @override
  void initState() {
    //podemos colocar requisições HTTP, load data de um server ou load data de uma database
    //o super se refere ao parent (classe State que herdamos)
    //executamos o initState aqui e na classe pai
    print('initState()');
    super.initState();
  }

  //o Flutter nos dá acesso a Widget antiga para compararmos com a nova
  //e passar a informação para algum banco de dados por exemplo
  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    print('didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  //usado para fechar conexões e limpar o objeto da memória
  @override
  void dispose() {
    print('dispose()');
    super.dispose();
  }

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate; //não é final pq vai mudar

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount < 0 || _selectedDate == null)
      return;

    widget.transactionHandler(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop(); //fecha a janela do topo, no caso o modal
    //o contexto
  }

  //assim como o modal, podemos chamar o datepicker com o método do Flutter
  void _presentDatePicker() {
    showDatePicker(
      context: context, //variavel global
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(), //não pode selecionar datas no futuro
    ).then((pickedDate) {
      if (pickedDate == null) {
        return; //o usuário cancelou
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              // onChanged: (val) {
              //   titleInput = val;
              // },
              controller: _titleController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              controller: _amountController,
              keyboardType: TextInputType.number,
              // onChanged: (val) => amountInput = val,
              onSubmitted: (_) => _submitData(),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                        _selectedDate == null
                            ? 'No chosen data yet!'
                            : 'Picked date: ${DateFormat.yMd().format(_selectedDate)}',
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  AdaptiveFlatButton('Choose Date', _presentDatePicker)
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Add Transaction'),
            )
          ],
        ),
      ),
    );
  }
}
