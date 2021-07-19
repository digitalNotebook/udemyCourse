import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String questionText;

  Question(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, //o maximo de espaço horizontal
      margin: EdgeInsets.all(10), //margin de 10 em todos os lados
      child: Text(
        questionText,
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ),
    );
  }
}


//  return Text(
//       questionText,
//       style: TextStyle(fontSize: 28),
//       textAlign: TextAlign.center,
//     );

//o código acima não centraliza o texto, porque o código somente
//aloca espaço suficiente para que o texto se encaixe
//por isso precisamos colocá-lo em um container

// A convenção é ter somente um Widget por arquivo.

// Somente teremos 2 widgets no mesmo arquivo, caso seja necessário 
//para que os dois funcionem juntos e elas não sejam 
//reutilizadas em nenhum outro lugar. 

// É uma boa ideia separar as widgets em widgets menores 
//em arquivos diferentes para melhor desempenho da aplicação 
//e melhor manutenção do código, como no caso do Widget Text que 
//recebeu estilização e ficou com um código maior do que o Normal, 
//logo escondemos essa parte da Widget Principal. 
