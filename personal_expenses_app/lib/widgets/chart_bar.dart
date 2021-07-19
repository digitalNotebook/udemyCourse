import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal; //porcentagem do total

  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    //O LayoutBuilder nos permite acessar as medidas disponíveis para aplicar a uma widget
    //e não a tela inteira como no caso da classe MediaQuery
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: [
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              //diminui o texto para não haver quebra de linha
              child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
            ),
          ), //retiramos o valor depois da vírgula
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ), //espaço vazio
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            //vamos criar um background que é parcialmente preenchido
            //com ajuda da widget Stack
            //onde podemos colocar um elemento em cima do outro
            child: Stack(
              children: [
                //a barra em si com um fundo cinza mais claro
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Color.fromRGBO(220, 220, 220, 1), //light grey color
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                //Uma box com o tamanho definido pela porcentagem da altura
                FractionallySizedBox(
                  heightFactor: spendingPctOfTotal,
                  //um container com o background preenchido de acordo com a %
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(label),
            ),
          ),
        ],
      );
    });
  }
}
