import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  //referencia ao botão de expansão ou contração do Listile
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      //a animação será na altura
      //o main container deve ter uma base height de 95
      //lembrando que nosso main container deve ser maior que secundário
      height:
          _expanded ? min(widget.order.products.length * 22.0 + 110, 200) : 95,

      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              //formatamos a data e hora do nosso jeito
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              ),
            ),
            // if (_expanded)
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 10),
              //por conta da remoção do if, esse container não deve aparecer senão for expandido
              height: _expanded
                  ? min(widget.order.products.length * 22.0 + 10, 180)
                  : 0,
              child: ListView(
                children: [
                  ...widget.order.products
                      .map(
                        (eachProd) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              eachProd.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${eachProd.quantity}x \$${eachProd.price}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
