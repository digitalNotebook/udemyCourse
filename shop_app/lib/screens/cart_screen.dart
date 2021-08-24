import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';

import '../widgets/cart_item.dart';
import '../providers/cart.dart' show Cart;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //podemos fazer o wrap com consumer da widget que será reconstruída
    //
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  //ter espaço
                  SizedBox(
                    width: 10,
                  ),
                  //gera um espaço em branco
                  Spacer(),
                  //olhar no material design para lembrar o que é
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              ?.color),
                    ),
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            //uma listview não funciona diretamente na Column
            child: ListView.builder(
              itemBuilder: (ctx, index) => CartItem(
                cart.items.values.toList()[index].id,
                cart.items.keys.toList()[index],
                cart.items.values.toList()[index].price,
                cart.items.values.toList()[index].quantity,
                cart.items.values.toList()[index].title,
              ),
              itemCount: cart.itemCount,
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      //se nada foi adicionado ao carrinho ou estiver carregando, desabilitamos o botão
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              //entramos em modo de carga para exibir o loadingSpinner
              setState(() {
                _isLoading = true;
              });
              //Consultamos o Map e passamos os CartItem como lista
              //Não precisamos ficar ouvindo por mudanças, listen: false
              //Aguardamos a requisição POST
              await Provider.of<Orders>(context, listen: false).addOrdem(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              //saimos do modo de carga para deixar de exibir o loadingSpinner
              setState(() {
                _isLoading = false;
              });
              //Limpamos o carrinho
              widget.cart.clear();
            },
    );
  }
}
