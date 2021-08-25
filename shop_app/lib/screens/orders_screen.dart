import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;

  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    // Future.delayed(Duration.zero).then((_) async {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();

    //alternativa ao código acima, pois estamos usando o listen:false
    // _isLoading = true;
    // Provider.of<Orders>(context, listen: false)
    //     .fetchAndSetOrders()
    //     .then((value) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //removemos essa linha com o uso do FutureBuilder, para evitar um loop
    // var ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          //se a conexão está carregando aiinda
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
            //se tivemos um erro
          } else {
            if (dataSnapshot.hasError) {
              return Center(
                child: Text('An error occurred'),
              );
              //tudo ok, vamos exibir nossa lista
            } else {
              //usamos o Consumer para não causar um rebuild da tela
              return Consumer<Orders>(
                builder: (ctx, ordersData, child) => ListView.builder(
                  itemCount: ordersData.orders.length,
                  itemBuilder: (ctx, index) =>
                      OrderItem(ordersData.orders[index]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
