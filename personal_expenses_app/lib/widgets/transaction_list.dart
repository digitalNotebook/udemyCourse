import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

//Será nosso output da lista
class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  'No transactions addded yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: constraints.maxHeight * 0.4,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        //não vamos mais usar o ListView.builder, pois ele possui um bug com a Key
        // : ListView.builder(
        //     itemCount: transactions.length,
        //     itemBuilder: (context, index) {
        //       return TransactionItem(
        //           transaction: transactions[index], deleteTx: deleteTx);
        //     },
        //   );
        : ListView(
            children: transactions.map((eachTx) {
              return TransactionItem(
                // key: UniqueKey(), gera uma key diferente em todo o rebuild
                key: ValueKey(eachTx.id), //essa chama gera um valor unico
                transaction: eachTx,
                deleteTx: deleteTx,
              );
            }).toList(),
          );
  }
}
